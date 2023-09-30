//
//  AppState.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-24.
//

import Combine
import Foundation
import SwiftUI

@MainActor class AppState: ObservableObject {
	static let shared: AppState = AppState()
	
	private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
	
	enum AppMode {
		case welcome(WelcomeView.ViewModel)
		case onboarding(SiteOnboardingView.ViewModel)
		case home(HomeView.ViewModel)
	}
	
	enum AppAction {
		case changeAppMode(AppMode)
	}
	
	@Published var mode: AppMode?
	@Published var isUserLoggedIn: Bool = false
	
	@Published var isShowingRequestPayment: Bool = false
	@Published var requestPaymentVM: RequestPaymentView.ViewModel?
	
	@Published var bannerData: BannerData?
	
	//Clients
	let apiClient = APIClient.shared
	let cacheClient = CacheClient.shared
	let keychainClient = KeychainClient.shared
	
	init() {
		refreshAppMode()
	}
	
	private func refreshAppMode() {
		Task(priority: .high) {
			let businessDraft = await cacheClient.getData(key: .businessDraft)
			let onboardingVM = SiteOnboardingView.ViewModel(draft: businessDraft)
			
			let user = keychainClient.get(key: .user)
			let business = keychainClient.get(key: .business)
			
			//APPMode Logic
			/**
			 (1). If a user is logged in and they have a business site, take them to the HomeView
			 (2). If a user is logged in but does not have a business site, take them to the SiteOnboardingView to create one
			 (3). If a user is not logged in, take them to the WelcomeView
			 */
			if let user = user {
				self.isUserLoggedIn = true
				self.mode = nil
				if let business = business {
					await self.cacheClient.delete(key: .businessDraft)
					self.mode = .home(HomeView.ViewModel(user: user, business: business))
				} else {
					//Attempt to fetch the user's business
					apiClient.getBusinessAccount()
						.receive(on: DispatchQueue.main)
						.sink(
							receiveCompletion: { completion in
								switch completion {
								case .finished: return
								case .failure:
									self.mode = .onboarding(onboardingVM)
									return
								}
							},
							receiveValue: { business in
								Task {
									await self.cacheClient.delete(key: .businessDraft)
									self.keychainClient.set(key: .business, value: business)
									self.mode = .home(HomeView.ViewModel(user: user, business: business))
								}
							}
						)
						.store(in: &cancellableBag)
				}
			} else {
				if businessDraft != nil {
					self.mode = .onboarding(onboardingVM)
				} else {
					self.mode = .welcome(WelcomeView.ViewModel(onboardingVM: onboardingVM))
				}
				self.isUserLoggedIn = false
			}
		}
	}
	
	func setAppMode(_ mode: AppMode) {
		withAnimation(.default) {
			self.mode = mode
		}
	}
	
	func setRequestPaymentVM(_ viewModel: RequestPaymentView.ViewModel?) {
		if let viewModel = viewModel {
			self.isShowingRequestPayment = true
			self.requestPaymentVM = viewModel
		} else {
			self.isShowingRequestPayment = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				self.requestPaymentVM = nil
			}
		}
	}
	
	func updateUser(user: User) {
		self.keychainClient.set(key: .user, value: user)
	}
	
	func updateBusiness(business: Business) {
		self.keychainClient.set(key: .business, value: business)
	}
	
	func setUserBusiness(business: Business) {
		self.keychainClient.set(key: .business, value: business)
		self.refreshAppMode()
	}
	
	func logUserIn(_ authenticateResponse: AuthenticateResponse) {
		let user: User = User(
			firstName: authenticateResponse.firstName,
			lastName: authenticateResponse.lastName,
			email: authenticateResponse.email,
			interacEmail: authenticateResponse.interacEmail,
			phone: authenticateResponse.phone,
			role: authenticateResponse.role,
			accessToken: authenticateResponse.jwtToken,
			refreshToken: authenticateResponse.refreshToken
		)
		self.keychainClient.set(key: .user, value: user)
		self.refreshAppMode()
	}
	
	func logUserOut(isUserRequested: Bool) {
		self.keychainClient.clearAllKeys()
		self.cacheClient.clear()
		if isUserRequested {
			self.refreshAppMode()
		} else {
			self.bannerData = BannerData(timeOut: 4, detail: "Authentication failed: Please login to continue")
			Task {
				try? await Task.sleep(for: .seconds(4))
				self.refreshAppMode()
			}
		}
	}
}
