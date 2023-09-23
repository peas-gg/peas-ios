//
//  CustomerRepository.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-23.
//

import Combine
import Foundation
import IdentifiedCollections

@MainActor class CustomerRepository: ObservableObject {
	static let shared: CustomerRepository = CustomerRepository()
	
	let businessId: Business.ID?
	
	private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
	
	@Published var customers: IdentifiedArrayOf<Customer> = []
	
	@Published var isLoading: Bool = false
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
			if let customers = await cacheClient.getData(key: .customers) {
				self.customers = customers
			}
			refresh()
		}
	}
	
	func requestRefresh() {
		self.isLoading = true
		self.refresh()
	}
	
	private func refresh() {
		guard let businessId = self.businessId else { return }
		self.apiClient
			.getCustomers(businessId: businessId)
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
				receiveValue: { customers in
					self.isLoading = false
					let customers = IdentifiedArray(uniqueElements: customers)
					self.customers = customers
					Task {
						await self.cacheClient.setData(key: .customers, value: customers)
					}
				}
			)
			.store(in: &cancellableBag)
	}
}
