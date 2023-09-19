//
//  HomeVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-24.
//

import Combine
import Foundation

extension HomeView {
	@MainActor class ViewModel: ObservableObject {
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var siteVM: SiteView.ViewModel
		
		@Published var bannerData: BannerData?
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let keychainClient: KeychainClient = KeychainClient.shared
		
		init(user: User, business: Business) {
			self.siteVM = SiteView.ViewModel(isTemplate: false, business: business)
		}
		
		func refreshBusiness() {
			self.apiClient.getBusinessAccount()
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { completion in
						switch completion {
						case .finished: return
						case .failure(let error):
							self.bannerData = BannerData(error: error)
						}
					},
					receiveValue: { business in
						self.keychainClient.set(key: .business, value: business)
						self.siteVM.business = business
					}
				)
				.store(in: &cancellableBag)
		}
	}
}
