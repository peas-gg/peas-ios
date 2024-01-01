//
//  UpdateOrder.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-27.
//

import Foundation

struct UpdateOrder: Encodable {
	let orderId: Order.ID
	let orderStatus: Order.Status?
	let dateRange: DateRange?
}
