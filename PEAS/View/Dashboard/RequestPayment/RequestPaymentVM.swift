//
//  RequestPaymentVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-12.
//

import Foundation

extension RequestPaymentView {
	@MainActor class ViewModel: ObservableObject {
		let keypad: [String] = ["1", "2", "3", "4", "5", "6", "7" ,"8", "9", ".", "0", AppConstants.keypadDelete]
		
		@Published var priceText: String = "0"
		
		//Clients
		private let feedbackClient: FeedbackClient = FeedbackClient.shared
		
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
	}
}
