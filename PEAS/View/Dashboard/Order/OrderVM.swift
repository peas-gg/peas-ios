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
		
		let context: Context
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var business: Business
		@Published var order: Order
		@Published var isShowingCustomerCard: Bool = false
		@Published var action: OrderStatusAction?
		
		@Published var isLoading: Bool = false
		@Published var bannerData: BannerData?
		
		var orderAmount: Int {
			return order.payment?.total ?? order.price
		}
		
		var canRequestPayment: Bool {
			switch order.orderStatus {
			case .pending, .declined:
				return false
			case .approved:
				return order.payment == nil
			case .completed:
				return false
			}
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		
		init(context: Context, business: Business, order: Order) {
			self.context = context
			self.business = business
			self.order = order
		}
		
		func resetAlert() {
			self.action = nil
		}
		
		func approveOrder() {
			updateOrder(orderStatus: .approved)
		}
		
		func declineOrder() {
			updateOrder(orderStatus: .declined)
		}
		
		func completeOrder() {
			updateOrder(orderStatus: .completed)
		}
		
		func updateOrder(orderStatus: Order.Status) {
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
					receiveValue: { order in
						self.isLoading = false
						self.order = order
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
		
		func openCustomerView() {
			self.isShowingCustomerCard = true
		}
	}
}
