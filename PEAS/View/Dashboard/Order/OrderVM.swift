//
//  OrderVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import Combine
import Foundation

extension OrderView {
	@MainActor class ViewModel: ObservableObject {
		enum Context: Equatable {
			case detail
			case dashboard
			case calendar
		}
		
		enum OrderStatusAction: String, Equatable {
			case decline
			case approve
			case complete
		}
		
		enum Sheet: String, Equatable, Identifiable {
			case customer
			case datePicker
			
			var id: String { self.rawValue }
		}
		
		let context: Context
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var business: Business
		@Published var order: Order
		@Published var action: OrderStatusAction?
		@Published var sheet: Sheet?
		
		@Published var dayForPicker: Date {
			didSet {
				updateTimePickers()
			}
		}
		
		@Published var startDateForPicker: Date
		@Published var endDateForPicker: Date
		
		@Published var isLoading: Bool = false
		@Published var isProcessingSheetRequest: Bool = false
		@Published var bannerData: BannerData?
		@Published var sheetBannerData: BannerData?
		
		var orderAmount: Int {
			if isOrderPaidFor {
				if let payment = order.payment {
					return payment.deposit + payment.base + payment.tip
				}
			}
			return order.price
		}
		
		var canRequestPayment: Bool {
			switch order.orderStatus {
			case .Pending, .Declined:
				return false
			case .Approved:
				return !isOrderPaidFor
			case .Completed:
				return false
			}
		}
		
		var isOrderPaidFor: Bool {
			if order.price > 0 {
				return order.payment?.total ?? 0 > 0
			} else {
				return true
			}
		}
		
		var isOrderTimeValid: Bool {
			endDateForPicker > startDateForPicker
		}
		
		var didOrderTimeChange: Bool {
			startDateForPicker != order.startTimeDate || endDateForPicker != order.endTimeDate
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		
		init(context: Context, business: Business, order: Order) {
			self.context = context
			self.business = business
			self.order = order
			self.dayForPicker = order.startTimeDate
			self.startDateForPicker = order.startTimeDate
			self.endDateForPicker = order.endTimeDate
			
			//Register for updates
			OrderRepository.shared
				.$orders
				.sink { orders in
					if let order = orders[id: self.order.id] {
						if order != self.order {
							self.order = order
						}
					}
				}
				.store(in: &cancellableBag)
		}
		
		func resetAlert() {
			self.action = nil
		}
		
		func approveOrder() {
			updateOrder(orderStatus: .Approved)
		}
		
		func declineOrder() {
			updateOrder(orderStatus: .Declined)
		}
		
		func completeOrder() {
			updateOrder(orderStatus: .Completed)
		}
		
		func updateTimePickers() {
			let dayComponents: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dayForPicker)
			let timeComponents: Set<Calendar.Component> = [.hour, .minute]
			
			let startTimeComponents: DateComponents = Calendar.current.dateComponents(timeComponents, from: startDateForPicker)
			let endTimeComponents: DateComponents = Calendar.current.dateComponents(timeComponents, from: endDateForPicker)
			
			var startDateComponents: DateComponents = dayComponents
			var endDateComponents: DateComponents = dayComponents
			
			startDateComponents.hour = startTimeComponents.hour
			startDateComponents.minute = startTimeComponents.minute
			endDateComponents.hour = endTimeComponents.hour
			endDateComponents.minute = endTimeComponents.minute
			
			self.startDateForPicker = Calendar.current.date(from: startDateComponents) ?? Date.now
			self.endDateForPicker = Calendar.current.date(from: endDateComponents) ?? Date.now
		}
		
		func updateOrderTime() {
			let startTime: String = ServerDateFormatter.formatToUTC(from: startDateForPicker)
			let endTime: String = ServerDateFormatter.formatToUTC(from: endDateForPicker)
			updateOrder(dateRange: DateRange(start: startTime, end: endTime))
		}
		
		func updateOrder(orderStatus: Order.Status? = nil, dateRange: DateRange? = nil) {
			if sheet == nil {
				self.isLoading = true
			} else {
				self.isProcessingSheetRequest = true
			}
			let updateOrder: UpdateOrder = UpdateOrder(
				orderId: order.id,
				orderStatus: orderStatus,
				dateRange: dateRange
			)
			self.apiClient
				.updateOrder(businessId: business.id, updateOrder)
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { completion in
						switch completion {
						case .finished: return
						case .failure(let error):
							self.isLoading = false
							self.isProcessingSheetRequest = false
							if self.sheet == nil {
								self.bannerData = BannerData(error: error)
							} else {
								self.sheetBannerData = BannerData(error: error)
							}
						}
					},
					receiveValue: { orderResponse in
						self.isLoading = false
						self.isProcessingSheetRequest = false
						OrderRepository.shared.update(order: Order(orderResponse: orderResponse))
					}
				)
				.store(in: &cancellableBag)
		}
		
		func requestAction(action: OrderStatusAction) {
			self.action = action
		}
		
		func requestPayment() {
			AppState.shared.setRequestPaymentVM(RequestPaymentView.ViewModel(business: business, order: order))
		}
		
		func setSheet(_ sheet: Sheet) {
			self.sheet = sheet
		}
	}
}
