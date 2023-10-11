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
		
		@Published var business: Business
		@Published var customers: IdentifiedArrayOf<Customer>
		
		@Published var isLoading: Bool = false
		@Published var bannerData: BannerData?
		
		//Clients
		private var apiClient: APIClient = APIClient.shared
		private var cacheClient: CacheClient = CacheClient.shared
		
		init(business: Business, customers: IdentifiedArrayOf<Customer> = []) {
			self.business = business
			self.customers = customers
			self.setUp()
			
			//Register for Notifications
			NotificationCenter
				.default.addObserver(
					self,
					selector: #selector(refresh),
					name: .refreshApp,
					object: nil
				)
		}
		
		func setUp() {
			Task(priority: .high) {
				if let customers = await cacheClient.getData(key: .customers) {
					self.customers = customers
				} else {
					self.isLoading = true
				}
				refresh()
			}
		}
		
		@objc func refresh() {
			self.apiClient
				.getCustomers(businessId: business.id)
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
