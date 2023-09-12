//
//  RequestPaymentVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-12.
//

import Foundation

extension RequestPaymentView {
	@MainActor class ViewModel: ObservableObject {
		let keypad: [String] = ["1", "2", "3", "4", "5", "6", "7" ,"8", "9", ".", "0", "delete"]
	}
}
