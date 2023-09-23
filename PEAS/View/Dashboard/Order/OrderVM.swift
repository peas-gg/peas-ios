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
			case minimal
			case calendar
		}
		
		let context: Context
		
		@Published var order: Order
		
		init(context: Context, order: Order) {
			self.context = context
			self.order = order
		}
		
		func approveOrder() {
			
		}
		
		func declineOrder() {
			
		}
	}
}
