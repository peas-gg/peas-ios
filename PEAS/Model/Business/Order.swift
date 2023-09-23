//
//  Order.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import Foundation

struct Order: Codable, Identifiable {
	enum Status: String, Equatable {
		case pending
		case approved
		case declined
		case completed
	}
	
	let id: String
	let customer: Customer
	let currency: Currency
	let price: Int
	let title: String
	let description: String
	let image: URL
	let note: String?
	let startTime: String
	let endTime: String
	let orderStatus: String
	let didRequestPayment: Bool
	let payment: Payment?
	let created: String
}
