//
//  OrderResponse.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-02.
//

import Foundation

struct OrderResponse : Decodable {
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
	let orderStatus: Order.Status
	let didRequestPayment: Bool
	let payment: Payment?
	let created: String
	let lastUpdated: String
}
