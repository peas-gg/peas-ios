//
//  WithdrawalResponse.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct WithdrawalResponse: Decodable {
	let amount: Int
	let withdrawalStatus: Withdrawal.Status
	let created: String
	let completed: String?
}
