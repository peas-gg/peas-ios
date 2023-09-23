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
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var customers: IdentifiedArrayOf<Customer> = []
		
		@Published var bannerData: BannerData?
		
		//Clients
		private var apiClient: APIClient = APIClient.shared
		private var cacheClient: CacheClient = CacheClient.shared
		
		//Repositories
		var customerRepository: CustomerRepository = CustomerRepository.shared
		
		init() {
			setUp()
			
			//Observe updates for customers
			self.customerRepository
				.$customers
				.sink(receiveValue: { customers in
					self.customers = customers
				})
				.store(in: &cancellableBag)
		}
		
		func setUp() {
			self.customers = customerRepository.customers
		}
		
		func refresh() {
			self.customerRepository.requestRefresh()
		}
	}
}
