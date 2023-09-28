//
//  CalendarVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import Combine
import Foundation
import IdentifiedCollections
import SwiftUI

extension CalendarView {
	@MainActor class ViewModel: ObservableObject {
		enum Route: Hashable {
			case order(Order)
		}
		
		let months: [Date]
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var isExpanded: Bool = false
		
		@Published var business: Business
		
		@Published var orders: IdentifiedArrayOf<Order>
		@Published var currentShowingOrders: IdentifiedArrayOf<Order>
		@Published var daysWithOrders: Set<Date>
		
		@Published var selectedDate: Date
		@Published var selectedDateIndex: Int
		
		@Published var navStack: [Route] = []
		
		//Clients
		let apiClient: APIClient = APIClient.shared
		let cacheClient: CacheClient = CacheClient.shared
		let calendarClient: CalendarClient = CalendarClient.shared
		
		init(business: Business, orders: IdentifiedArrayOf<Order> = []) {
			self.months = calendarClient.months
			
			self.selectedDate = calendarClient.getStartOfDay(Date.now)
			self.selectedDateIndex = 0
			
			self.business = business
			self.orders = orders
			self.currentShowingOrders = []
			self.daysWithOrders = []
			
			refresh()
			
			self.$orders
				.sink { _ in self.updateDaysWithOrders() }
				.store(in: &cancellableBag)
		}
		
		func refresh() {
			Task {
				if let orders = await cacheClient.getData(key: .orders) {
					self.orders = orders
				}
				setCurrentOrders()
			}
		}
		
		func updateDaysWithOrders() {
			self.daysWithOrders = Set(self.orders.map { self.calendarClient.getStartOfDay($0.startTimeDate) })
		}
		
		func setCurrentOrders() {
			//Sort orders based on dates then sort them in descending order
			let sortedOrders: [Order] = orders
				.filter { calendarClient.getStartOfDay($0.startTimeDate) == self.selectedDate }
				.sorted(by: { $0.startTimeDate < $1.startTimeDate })
			self.currentShowingOrders = IdentifiedArray(uniqueElements: sortedOrders)
		}
		
		func setSelectedDateIndex() {
			let month: Date = self.selectedDate.startOfMonth()
			let index = (self.months.firstIndex(of: month) ?? 0)
			self.selectedDateIndex = index / 2
		}
		
		func dateSelected(date: Date) {
			self.selectedDate = date
			setCurrentOrders()
			if self.isExpanded {
				withAnimation(.default) {
					self.isExpanded.toggle()
				}
			}
		}
		
		func pushStack(_ route: Route) {
			self.navStack.append(route)
		}
	}
}
