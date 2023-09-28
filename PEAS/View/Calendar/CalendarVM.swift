//
//  CalendarVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import Foundation
import IdentifiedCollections
import SwiftUI

extension CalendarView {
	@MainActor class ViewModel: ObservableObject {
		
		let months: [Date] = CalendarClient.shared.months
		
		@Published var isExpanded: Bool = false
		
		@Published var business: Business
		
		@Published var orders: IdentifiedArrayOf<Order>
		@Published var currentOrders: IdentifiedArrayOf<Order>
		
		@Published var selectedDate: Date = Date.now
		@Published var selectedDateIndex: Int = 0
		
		//Clients
		let apiClient: APIClient = APIClient.shared
		let cacheClient: CacheClient = CacheClient.shared
		
		init(business: Business, orders: IdentifiedArrayOf<Order> = []) {
			self.business = business
			self.orders = orders
			self.currentOrders = [Order.mock1, Order.mock2]
			refresh()
		}
		
		func refresh() {
			Task {
				if let orders = await cacheClient.getData(key: .orders) {
					self.orders = orders
					setCurrentOrders()
				}
			}
		}
		
		func setCurrentOrders() {
			//Sort orders based on dates then sort them in descending order
		}
		
		func setSelectedDateIndex() {
			let month: Date = self.selectedDate.startOfMonth()
			let index = (self.months.firstIndex(of: month) ?? 0)
			self.selectedDateIndex = index / 2
		}
		
		func dateSelected(date: Date) {
			self.selectedDate = date
			withAnimation(.default) {
				self.isExpanded.toggle()
			}
		}
	}
}
