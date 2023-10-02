//
//  RequestPaymentVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-12.
//

import Combine
import Foundation

extension RequestPaymentView {
	@MainActor class ViewModel: ObservableObject {
		let keypad: [String] = ["1", "2", "3", "4", "5", "6", "7" ,"8", "9", ".", "0", AppConstants.keypadDelete]
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var business: Business
		@Published var order: Order
		@Published var priceText: String
		
		@Published var bannerData: BannerData?
		@Published var isLoading: Bool = false
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let feedbackClient: FeedbackClient = FeedbackClient.shared
		
		init(business: Business, order: Order) {
			self.business = business
			self.order = order
			self.priceText = String(order.price)
		}
		
		func keyTapped(key: String) {
			if key == AppConstants.keypadDelete && priceText.count >= 1 {
				priceText.removeLast()
				feedbackClient.light()
				return
			}
			if priceText.count <= 10 {
				if Int(key) != nil {
					priceText.append(key)
					feedbackClient.light()
				}
			}
		}
		
		func request() {
			self.isLoading = true
			let requestPayment: RequestPayment = RequestPayment(
				orderId: order.id,
				price: Int(priceText) ?? 0
			)
			self.apiClient
				.requestPayment(businessId: self.business.id, requestPayment)
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
					receiveValue: { orderResponse in
						Task {
							self.order = Order(orderResponse: orderResponse)
							self.bannerData = BannerData(isSuccess: true, detail: "Sent")
							self.isLoading = false
							OrderRepository.shared.update(order: self.order)
							try await Task.sleep(for: .seconds(1))
							AppState.shared.setRequestPaymentVM(nil)
						}
					}
				)
				.store(in: &cancellableBag)
		}
	}
}
