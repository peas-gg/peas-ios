//
//  WithdrawalResponse.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct WithdrawalResponse: Decodable {
	enum Status: Decodable {
		case Pending
		case Succeeded
		case Failed
	}
	let amount: Int
	let withdrawalStatus: Status
	let created: String
	let completed: String?
}
