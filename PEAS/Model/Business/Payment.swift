//
//  Payment.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import Foundation

struct Payment: Equatable, Codable {
	let id: Int
	let currency: Currency
	let base: Int
	let deposit: Int
	let tip: Int
	let fee: Int
	let total: Int
	let created: String
}
