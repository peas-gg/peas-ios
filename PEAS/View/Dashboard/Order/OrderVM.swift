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
		
		@Published var business: Business
		@Published var order: Order
		@Published var isShowingCustomerCard: Bool = false
		@Published var action: OrderStatusAction?
		
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
		
		init(context: Context, business: Business, order: Order) {
			self.context = context
			self.business = business
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
			AppState.shared.setRequestPaymentVM(RequestPaymentView.ViewModel(business: business, order: order))
		}
		
		func openCustomerView() {
			self.isShowingCustomerCard = true
		}
	}
}
