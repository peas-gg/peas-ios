//
//  CustomersVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import Combine
import IdentifiedCollections
import Foundation

extension CustomersView {
	@MainActor class ViewModel: ObservableObject {
		let businessId: Business.ID
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var customers: IdentifiedArrayOf<Customer>
		
		@Published var isLoading: Bool = false
		@Published var bannerData: BannerData?
		
		//Clients
		private var apiClient: APIClient = APIClient.shared
		private var cacheClient: CacheClient = CacheClient.shared
		
		init(businessId: Business.ID, customers: IdentifiedArrayOf<Customer> = []) {
			self.businessId = businessId
			self.customers = customers
			setUp()
		}
		
		func setUp() {
			Task(priority: .high) {
				if let cachedCustomers = await cacheClient.getData(key: .customers) {
					self.customers = cachedCustomers
				} else {
					self.isLoading = true
				}
			}
		}
		
		func refresh() {
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
}
