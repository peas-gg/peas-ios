//
//  OrderVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

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
		
		@Published var order: Order
		@Published var isShowingCustomerCard: Bool = false
		@Published var action: OrderStatusAction?
		
		var orderAmount: Int {
			return order.payment?.total ?? order.price
		}
		
		init(context: Context, order: Order) {
			self.context = context
			self.order = order
		}
		
		func resetAlert() {
			self.action = nil
		}
		
		func approveOrder() {
			
		}
		
		func declineOrder() {
			
		}
		
		func completeOrder() {
			
		}
		
		func requestAction(action: OrderStatusAction) {
			self.action = action
		}
		
		func requestPayment() {
			AppState.shared.setIsShowingPaymentView(true)
		}
		
		func openCustomerView() {
			self.isShowingCustomerCard = true
		}
	}
}
