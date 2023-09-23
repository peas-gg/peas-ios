//
//  OrderVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import Foundation

extension OrderView {
	@MainActor class ViewModel: ObservableObject {
		@Published var order: Order
		
		init(order: Order) {
			self.order = order
		}
	}
}
