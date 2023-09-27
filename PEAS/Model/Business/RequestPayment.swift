//
//  RequestPayment.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-27.
//

import Foundation

struct RequestPayment: Encodable {
	let orderId: Order.ID
	let price: Int
}
