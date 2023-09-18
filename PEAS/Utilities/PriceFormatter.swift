//
//  PriceFormatter.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import Foundation

struct PriceFormatter {
	private static let factor: Int = 100
	
	static let formatter: NumberFormatter =  {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}()
	
	static func price(value: String) -> String {
		let price: Double = Double(Int(value) ?? 0) / Double(factor)
		return formatter.string(from: price as NSNumber) ?? ""
	}
}
