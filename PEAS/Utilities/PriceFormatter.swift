//
//  PriceFormatter.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import Foundation

struct PriceFormatter {
	private let factor: Double = 0.01
	
	let price: Double
	let text: String
	
	init(text: String) {
		self.price = Double(Int(text) ?? 0) * factor
		self.text = text
	}
	
	init(price: Double) {
		self.price = price
		self.text = String(Int((price / factor)))
	}
}
