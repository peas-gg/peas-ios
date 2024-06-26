//
//  Payment.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import Foundation

struct Payment: Equatable, Codable, Hashable {
	let id: Int
	let base: Int
	let deposit: Int
	let tip: Int
	let fee: Int
	let total: Int
	let created: String
	let completed: String?
}

extension Payment {
	static var mock1: Self {
		return Payment(
			id: 0,
			base: 12000,
			deposit: 0,
			tip: 1200,
			fee: 0,
			total: 13200,
			created: "2023-09-22T07:50:00Z",
			completed: nil
		)
	}
}
