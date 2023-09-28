//
//  OrderRepository.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-28.
//

import Foundation
import IdentifiedCollections

@MainActor class OrderRepository: ObservableObject {
	static let shared: OrderRepository = OrderRepository()
	
	@Published var orders: IdentifiedArrayOf<Order> = []
	
	init() { }
	
	func update(order: Order) {
		self.orders.updateOrAppend(order)
	}
}
