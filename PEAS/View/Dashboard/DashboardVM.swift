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
		}
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var user: User
		@Published var business: Business
		@Published var unSortedOrders: IdentifiedArrayOf<Order>
		
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
			unSortedOrders.sorted(by: { $0.created > $1.created })
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let keychainClient: KeychainClient = KeychainClient.shared
		
		init(user: User, business: Business, orders: IdentifiedArrayOf<Order> = []) {
			self.user = user
			self.business = business
			self.unSortedOrders = orders
			setUp()
			
			//Register for updates
			OrderRepository.shared
				.$orders
				.sink { orders in
					self.unSortedOrders = orders
				}
				.store(in: &cancellableBag)
		}
		
		func setUp() {
			self.unSortedOrders = OrderRepository.shared.orders
			refreshOrders()
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
		
		func refreshOrders() {
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
		
		func refresh() {
			if let user = keychainClient.get(key: .user) {
				self.user = user
			}
			if let business = keychainClient.get(key: .business) {
				self.business = business
			}
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
		
		func setIsShowingCashOut(_ isShowing: Bool) {
			self.isShowingCashOut = isShowing
		}
		
		func setIsShowingCashOutOnboarding(_ isShowing: Bool) {
			self.isShowingCashOutOnboarding = isShowing
		}
		
		func pushStack(_ route: Route) {
			self.navStack.append(route)
		}
	}
}
