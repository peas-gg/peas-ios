//
//  CashOutVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-24.
//

import Combine
import Foundation

extension CashOutView {
	@MainActor class ViewModel: ObservableObject {
		enum Context {
			case onboarding
			case cashOut
		}
		
		enum EmailSelection {
			case account
			case different
		}
		
		let context: Context
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var user: User
		@Published var business: Business
		@Published var wallet: Wallet
		
		@Published var currentEmailSelection: EmailSelection = .account
		@Published var differentEmail: String = ""
		@Published var isShowingConfirmation: Bool = false
		
		@Published var dismiss: Bool = false
		
		@Published var slidingButtonStatus: SlidingButtonView.Status = .unknown
		
		@Published var isLoading: Bool = false
		@Published var bannerData: BannerData?
		
		var selectedEmail: String {
			switch currentEmailSelection {
			case .account: return user.email
			case .different: return differentEmail
			}
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let keychainClient: KeychainClient = KeychainClient.shared
		
		init(context: Context, user: User, business: Business, wallet: Wallet) {
			self.context = context
			self.user = user
			self.business = business
			self.wallet = wallet
			
			//Register for updates
			WalletRepository.shared
				.$wallet
				.sink { wallet in
					self.wallet = wallet
				}
				.store(in: &cancellableBag)
		}
		
		func selectEmail(selection: EmailSelection) {
			switch selection {
			case .account:
				self.currentEmailSelection = selection
			case .different:
				if differentEmail.isValidEmail {
					self.currentEmailSelection = selection
				}
			}
		}
		
		func setIsShowingConfirmation(_ isShowing: Bool) {
			self.isShowingConfirmation = isShowing
		}
		
		func advance() {
			switch context {
			case .onboarding:
				if self.isShowingConfirmation {
					self.isLoading = true
					self.apiClient
						.setInteracEmail(selectedEmail)
						.receive(on: DispatchQueue.main)
						.sink(
							receiveCompletion: { completion in
								switch completion {
								case .finished: return
								case .failure(let error):
									self.isLoading = false
									self.bannerData = BannerData(error: error)
									return
								}
							},
							receiveValue: { email in
								if let user = self.keychainClient.get(key: .user) {
									let updatedUser = User(
										firstName: user.firstName,
										lastName: user.lastName,
										email: user.email,
										interacEmail: email,
										phone: user.phone,
										role: user.role,
										accessToken: user.accessToken,
										refreshToken: user.refreshToken
									)
									AppState.shared.updateUser(user: updatedUser)
									
									self.isLoading = false
									self.dismiss.toggle()
								}
							}
						)
						.store(in: &cancellableBag)
				} else {
					self.isShowingConfirmation = true
				}
			case .cashOut:
				self.slidingButtonStatus = .inProgress
				self.apiClient
					.withdraw(businessId: business.id)
					.receive(on: DispatchQueue.main)
					.sink(
						receiveCompletion: { completion in
							switch completion {
							case .finished: return
							case .failure(let error):
								self.slidingButtonStatus = .unknown
								self.bannerData = BannerData(error: error)
								return
							}
						},
						receiveValue: { walletResponse in
							WalletRepository.shared.update(wallet: Wallet(walletResponse: walletResponse))
							self.slidingButtonStatus = .success
						}
					)
					.store(in: &cancellableBag)
			}
		}
	}
}
