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
		@Published var orders: IdentifiedArrayOf<Order>
		
		@Published var isShowingFilterMenu: Bool = false
		@Published var selectedOrderFilter: Order.Status?
		
		@Published var navStack: [Route] = []
		
		@Published var bannerData: BannerData?
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let cacheClient: CacheClient = CacheClient.shared
		
		init(user: User, business: Business, orders: IdentifiedArrayOf<Order> = []) {
			self.user = user
			self.business = business
			self.orders = orders
			setUp()
		}
		
		func setUp() {
			Task(priority: .high) {
				if let orders = await cacheClient.getData(key: .orders) {
					self.orders = orders
				}
				refreshOrders()
			}
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
					receiveValue: { orders in
						self.orders = IdentifiedArray(uniqueElements: orders)
					}
				)
				.store(in: &cancellableBag)
		}
		
		func pushStack(_ route: Route) {
			self.navStack.append(route)
		}
	}
}
