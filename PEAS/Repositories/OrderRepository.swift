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
	
	//Clients
	private let cacheClient: CacheClient = CacheClient.shared
	
	init() {
		setUp()
	}
	
	func update(order: Order) {
		self.orders.updateOrAppend(order)
		update()
	}
	
	func update(orders: [Order]) {
		self.orders = IdentifiedArray(uniqueElements: orders)
		update()
	}
	
	private func setUp() {
		Task {
			if let orders = await cacheClient.getData(key: .orders) {
				self.orders = orders
			}
		}
	}
	
	private func update() {
		Task {
			await cacheClient.setData(key: .orders, value: self.orders)
		}
	}
}
