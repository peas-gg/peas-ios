//
//  DashboardVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//
import Combine
import Foundation
import IdentifiedCollections
import SwiftUI

extension DashboardView {
	@MainActor class ViewModel: ObservableObject {
		enum Route: Hashable {
			case order(Order)
			case transactions
		}
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var user: User
		@Published var business: Business
		@Published var unSortedOrders: IdentifiedArrayOf<Order>
		@Published var wallet: Wallet
		
		@Published var isShowingUserView: Bool = false
		@Published var isShowingFilterMenu: Bool = false
		@Published var selectedOrderFilter: Order.Status?
		
		@Published var isShowingCashOutOnboarding: Bool = false
		@Published var isShowingCashOut: Bool = false
		
		@Published var navStack: [Route] = []
		
		@Published var bannerData: BannerData?
		
		var currentShowingOrders: [Order] {
			switch selectedOrderFilter {
			case .Approved, .Completed, .Declined, .Pending:
				return orders.filter { $0.orderStatus == selectedOrderFilter }
			case .none:
				return orders
			}
		}
		
		var pendingServicesText: String {
			let noOfPendingServices: Int = orders.filter { $0.orderStatus == .Pending }.count
			if noOfPendingServices > 0 {
				return " (\(noOfPendingServices) pending)"
			} else {
				return ""
			}
		}
		
		var orders: [Order] {
			unSortedOrders.sorted(by: { $0.lastUpdated > $1.lastUpdated })
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let keychainClient: KeychainClient = KeychainClient.shared
		
		init(
			user: User,
			business: Business,
			orders: IdentifiedArrayOf<Order> = [],
			wallet: Wallet = Wallet(
				walletResponse: WalletResponse(
					balance: 0,
					holdBalance: 0,
					transactions: []
				)
			)
		) {
			self.user = user
			self.business = business
			self.unSortedOrders = orders
			self.wallet = wallet
			setUp()
			
			registerForPushNotifications()
			
			//Register for updates
			WalletRepository.shared
				.$wallet
				.sink { wallet in
					self.wallet = wallet
				}
				.store(in: &cancellableBag)
			
			OrderRepository.shared
				.$orders
				.sink { orders in
					self.unSortedOrders = orders
				}
				.store(in: &cancellableBag)
			
			//Register for Notifications
			NotificationCenter
				.default.addObserver(
					self,
					selector: #selector(refresh),
					name: .refreshApp,
					object: nil
				)
			
			NotificationCenter
				.default.addObserver(
					self,
					selector: #selector(refreshOrders),
					name: .refreshOrders,
					object: nil
				)
			
			NotificationCenter
				.default.addObserver(
					self,
					selector: #selector(refreshWallet),
					name: .refreshWallet,
					object: nil
				)
		}
		
		func setUp() {
			self.unSortedOrders = OrderRepository.shared.orders
			refreshOrders()
			refreshWallet()
		}
		
		func toggleFilterMenu() {
			withAnimation(.default) {
				if self.selectedOrderFilter == nil {
					self.isShowingFilterMenu = true
				} else {
					self.selectedOrderFilter = nil
				}
			}
		}
		
		func showUserView() {
			self.isShowingUserView = true
		}
		
		func selectFilter(_ orderFilter: Order.Status) {
			self.selectedOrderFilter = orderFilter
			withAnimation(.default) {
				self.isShowingFilterMenu = false
			}
		}
		
		@objc func refreshWallet() {
			self.apiClient
				.getWallet(businessId: business.id)
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { completion in
						switch completion {
						case .finished: return
						case .failure(let error):
							self.bannerData = BannerData(error: error)
							return
						}
					},
					receiveValue: { walletResponse in
						WalletRepository.shared.update(wallet: Wallet(walletResponse: walletResponse))
					}
				)
				.store(in: &cancellableBag)
		}
		
		@objc func refreshOrders() {
			self.apiClient
				.getOrders(businessId: business.id)
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { completion in
						switch completion {
						case .finished: return
						case .failure(let error):
							self.bannerData = BannerData(error: error)
							return
						}
					},
					receiveValue: { ordersResponse in
						OrderRepository.shared.update(orders: ordersResponse.compactMap({ Order(orderResponse: $0) }))
					}
				)
				.store(in: &cancellableBag)
		}
		
		@objc func refresh() {
			if let user = keychainClient.get(key: .user) {
				self.user = user
			}
			if let business = keychainClient.get(key: .business) {
				self.business = business
			}
			refreshWallet()
			refreshOrders()
		}
		
		func didCloseCashOutOnboarding() {
			Task {
				try await Task.sleep(for: .seconds(0.5))
				if let user = keychainClient.get(key: .user) {
					if user.interacEmail != nil {
						self.user = user
						cashOut()
					}
				}
			}
		}
		
		func cashOut() {
			if self.user.interacEmail == nil {
				setIsShowingCashOutOnboarding(true)
			} else {
				setIsShowingCashOut(true)
			}
		}
		
		func showTransactions() {
			self.navStack.append(.transactions)
		}
		
		func setIsShowingCashOut(_ isShowing: Bool) {
			self.isShowingCashOut = isShowing
		}
		
		func setIsShowingCashOutOnboarding(_ isShowing: Bool) {
			self.isShowingCashOutOnboarding = isShowing
		}
		
		func pushStack(_ route: Route) {
			self.navStack.append(route)
		}
		
		func registerForPushNotifications() {
			UNUserNotificationCenter
				.current()
				.requestAuthorization(
					options: [.alert, .sound, .badge]
				) { granted, _ in
					guard granted else { return }
					UNUserNotificationCenter
						.current()
						.getNotificationSettings { settings in
							guard settings.authorizationStatus == .authorized else { return }
							DispatchQueue.main.async {
								UIApplication.shared.registerForRemoteNotifications()
							}
						}
				}
		}
	}
}
