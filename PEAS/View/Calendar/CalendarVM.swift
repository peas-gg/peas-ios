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
		
		enum Sheet: String, Equatable, Identifiable {
			case timeBlock
			
			var id: String { self.rawValue }
		}
		
		let months: [Date]
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var isExpanded: Bool = false
		
		@Published var business: Business
		
		@Published var orders: IdentifiedArrayOf<Order>
		@Published var timeBlocks: IdentifiedArrayOf<TimeBlock>
		@Published var events: IdentifiedArrayOf<CalendarEvent>
		@Published var currentShowingEvents: IdentifiedArrayOf<CalendarEvent>
		@Published var daysWithEvents: Set<Date>
		
		@Published var selectedDate: Date
		@Published var selectedDateIndex: Int
		
		@Published var timeBlockContext: TimeBlockView.Context = .add
		@Published var timeBlockStartTime: Date = Date.now
		@Published var timeBlockEndTime: Date = Date.now
		@Published var timeBlockTitle: String = ""
		@Published var currentShowingTimeBlock: TimeBlock?
		@Published var isShowingTimeBlockDeleteAlert: Bool = false
		
		@Published var isProcessingSheetRequest: Bool = false
		@Published var sheetBannerData: BannerData?
		
		@Published var bannerData: BannerData?
		
		@Published var sheet: Sheet?
		@Published var navStack: [Route] = []
		
		var canSaveTheBlockedTime: Bool {
			!timeBlockTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
			&& (timeBlockEndTime > timeBlockStartTime)
		}
		
		//Clients
		let apiClient: APIClient = APIClient.shared
		let cacheClient: CacheClient = CacheClient.shared
		let calendarClient: CalendarClient = CalendarClient.shared
		
		init(business: Business, orders: IdentifiedArrayOf<Order> = [], timeBlocks: IdentifiedArrayOf<TimeBlock> = []) {
			self.months = calendarClient.months
			
			self.selectedDate = calendarClient.getStartOfDay(Date.now)
			self.selectedDateIndex = 0
			
			self.business = business
			self.orders = orders
			self.timeBlocks = timeBlocks
			self.events = []
			self.currentShowingEvents = []
			self.daysWithEvents = []
			
			refresh()
			
			//Update Events as Orders and TimeBlocks change
			$orders
				.sink { _ in self.updateEvents() }
				.store(in: &cancellableBag)
			
			$timeBlocks
				.receive(on: DispatchQueue.main)
				.sink { _ in self.updateEvents() }
				.store(in: &cancellableBag)
			
			//Register for updates
			OrderRepository.shared
				.$orders
				.sink { orders in
					self.orders = orders
				}
				.store(in: &cancellableBag)
			
			TimeBlockRepository.shared
				.$timeBlocks
				.sink { timeBlocks in
					self.timeBlocks = timeBlocks
				}
				.store(in: &cancellableBag)
			
			//Register for Notifications
			NotificationCenter
				.default.addObserver(
					self,
					selector: #selector(didAppear),
					name: .refreshApp,
					object: nil
				)
		}
		
		@objc func didAppear() {
			self.setSelectedDateIndex()
			self.refresh()
		}
		
		func refresh() {
			Task {
				self.orders = OrderRepository.shared.orders
				self.timeBlocks = TimeBlockRepository.shared.timeBlocks
				self.getTimeBlocks()
			}
		}
		
		func updateEvents() {
			var calendarEvents: IdentifiedArrayOf<CalendarEvent> = []
			let orderEvents: IdentifiedArrayOf<CalendarEvent>  = IdentifiedArray(uniqueElements: filteredOrders(orders: orders).map { CalendarEvent(event: .order($0)) })
			calendarEvents.append(contentsOf: orderEvents)
			
			let timeBlockEvents: IdentifiedArrayOf<CalendarEvent>  = IdentifiedArray(uniqueElements: timeBlocks.map { CalendarEvent(event: .timeBlock($0)) })
			calendarEvents.append(contentsOf: timeBlockEvents)
			
			self.events = calendarEvents
			self.updateDaysWithEvents()
			setCurrentEvents()
		}
		
		func updateDaysWithEvents() {
			var dates: [Date] = []
			self.events.forEach {
				dates.append(contentsOf: self.uniqueDaysBetween(startDate: $0.startTimeDate, endDate: $0.endTimeDate))
			}
			self.daysWithEvents = Set(dates)
		}
		
		func setCurrentEvents() {
			//Sort orders based on dates then sort them in descending order
			let sortedEvents: [CalendarEvent] = events
				.filter { uniqueDaysBetween(startDate: $0.startTimeDate, endDate: $0.endTimeDate).contains(self.selectedDate) }
				.sorted(by: { $0.startTimeDate < $1.startTimeDate })
			self.currentShowingEvents = IdentifiedArray(uniqueElements: sortedEvents)
		}
		
		func setSelectedDateIndex() {
			let month: Date = self.selectedDate.startOfMonth()
			let index = (self.months.firstIndex(of: month) ?? 0)
			self.selectedDateIndex = index / 2
		}
		
		func uniqueDaysBetween(startDate: Date, endDate: Date) -> [Date] {
			var uniqueDays: [Date] = []
			
			var currentDate = startDate
			let calendar = Calendar.current
			
			while currentDate <= endDate {
				uniqueDays.append(calendarClient.getStartOfDay(currentDate))
				guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
					break
				}
				currentDate = calendarClient.getStartOfDay(nextDate)
			}
			return uniqueDays
		}
		
		func dateSelected(date: Date) {
			self.selectedDate = date
			setCurrentEvents()
			if self.isExpanded {
				withAnimation(.default) {
					self.isExpanded.toggle()
				}
			}
		}
		
		func addNewTimeBlock() {
			self.timeBlockContext = .add
			self.timeBlockTitle = ""
			self.timeBlockStartTime = Date.now
			self.timeBlockEndTime = Date.now
			self.setSheet(.timeBlock)
		}
		
		func timeBlockTapped(_ timeBlock: TimeBlock) {
			self.timeBlockContext = .edit
			self.timeBlockTitle = timeBlock.title
			self.timeBlockStartTime = timeBlock.startTimeDate
			self.timeBlockEndTime = timeBlock.endTimeDate
			self.currentShowingTimeBlock = timeBlock
			self.setSheet(.timeBlock)
		}
		
		func setSheet(_ sheet: Sheet?) {
			self.sheet = sheet
		}
		
		func pushStack(_ route: Route) {
			self.navStack.append(route)
		}
		
		func filteredOrders(orders: IdentifiedArrayOf<Order>) -> IdentifiedArrayOf<Order> {
			return orders.filter { $0.orderStatus == .Approved || $0.orderStatus == .Completed }
		}
		
		func getTimeBlocks() {
			self.apiClient.getTimeBlocks(businessId: self.business.id)
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { completion in
						switch completion {
						case .finished: return
						case .failure(let error):
							self.bannerData = BannerData(error: error)
						}
					},
					receiveValue: { timeBlocksResponse in
						TimeBlockRepository.shared
							.update(timeBlocks: timeBlocksResponse.compactMap({ TimeBlock($0) } ))
					}
				)
				.store(in: &self.cancellableBag)
		}
		
		func onDeleteTimeBlock() {
			self.isShowingTimeBlockDeleteAlert = true
		}
		
		func deleteTimeBlock() {
			if let timeBlockToDelete = self.currentShowingTimeBlock {
				self.isProcessingSheetRequest = true
				self.apiClient
					.deleteTimeBlock(businessId: business.id, timeBlockToDelete.id)
					.receive(on: DispatchQueue.main)
					.sink(
						receiveCompletion: { completion in
							switch completion {
							case .finished: return
							case .failure(let error):
								self.isProcessingSheetRequest = false
								self.sheetBannerData = BannerData(error: error)
							}
						},
						receiveValue: { _ in
							TimeBlockRepository.shared.delete(timeBlock: timeBlockToDelete)
							self.isProcessingSheetRequest = false
							self.setSheet(nil)
						}
					)
					.store(in: &self.cancellableBag)
			}
		}
		
		func onSaveTimeBlock() {
			self.isProcessingSheetRequest = true
			let createTimeBlockModel: CreateTimeBlock = CreateTimeBlock(
				title: self.timeBlockTitle,
				startTime: ServerDateFormatter.formatToUTC(from: self.timeBlockStartTime),
				endTime: ServerDateFormatter.formatToUTC(from: self.timeBlockEndTime)
			)
			
			self.apiClient
				.createTimeBlock(businessId: business.id, createTimeBlockModel)
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { completion in
						switch completion {
						case .finished: return
						case .failure(let error):
							self.isProcessingSheetRequest = false
							self.sheetBannerData = BannerData(error: error)
						}
					},
					receiveValue: { timeBlockResponse in
						TimeBlockRepository.shared.update(timeBlock: TimeBlock(timeBlockResponse))
						self.isProcessingSheetRequest = false
						self.setSheet(nil)
					}
				)
				.store(in: &self.cancellableBag)
		}
	}
}
