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
		
		@Published var isLoading: Bool = false
		@Published var bannerData: BannerData?
		
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
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		
		init(context: Context, business: Business, order: Order) {
			self.context = context
			self.business = business
			self.order = order
			
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
		
		func updateOrder(orderStatus: Order.Status) {
			self.isLoading = true
			let updateOrder: UpdateOrder = UpdateOrder(
				orderId: order.id,
				orderStatus: orderStatus
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
							self.bannerData = BannerData(error: error)
						}
					},
					receiveValue: { orderResponse in
						self.isLoading = false
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
