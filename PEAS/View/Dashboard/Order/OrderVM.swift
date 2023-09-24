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
		
		let context: Context
		
		@Published var order: Order
		@Published var isShowingCustomerCard: Bool = false
		
		var orderAmount: Int {
			return order.payment?.total ?? order.price
		}
		
		init(context: Context, order: Order) {
			self.context = context
			self.order = order
		}
		
		func approveOrder() {
			
		}
		
		func declineOrder() {
			
		}
		
		func completeOrder() {
			
		}
		
		func requestPayment() {
			AppState.shared.setIsShowingPaymentView(true)
		}
		
		func openCustomerView() {
			self.isShowingCustomerCard = true
		}
	}
}
