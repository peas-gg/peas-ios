//
//  Withdrawal.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct Withdrawal: Codable {
	enum Status: Codable {
		case Pending
		case Succeeded
		case Failed
	}
	
	let amount: Int
	let withdrawalStatus: Status
	let created: Date
	let completed: Date?
}
