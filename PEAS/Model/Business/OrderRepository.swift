//
//  OrderRepository.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import Combine
import Foundation
import IdentifiedCollections

@MainActor class OrderRepository: ObservableObject {
	static let shared: OrderRepository = OrderRepository()
	
	let businessId: Business.ID?
	
	private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
	
	@Published var orders: IdentifiedArrayOf<Order> = []
	
	@Published var bannerData: BannerData?
	
	//Clients
	private let apiClient: APIClient = APIClient.shared
	private let cacheClient: CacheClient = CacheClient.shared
	private let keychainClient: KeychainClient = KeychainClient.shared
	
	init() {
		if let business = keychainClient.get(key: .business) {
			self.businessId = business.id
		} else {
			self.businessId = nil
		}
		Task(priority: .high) {
			if let orders = await cacheClient.getData(key: .orders) {
				self.orders = orders
			}
			refresh()
		}
	}
	
	func refresh() {
		guard let businessId = businessId else { return }
		self.apiClient
			.getOrders(businessId: businessId)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { completion in
					switch completion {
					case .finished: return
					case .failure(let error):
						self.bannerData = BannerData(error: error)
						return
					}
				},
				receiveValue: { orders in
					self.orders = IdentifiedArray(uniqueElements: orders)
				}
			)
			.store(in: &cancellableBag)
	}
}
