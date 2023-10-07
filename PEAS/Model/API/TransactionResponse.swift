//
//  TransactionResponse.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct TransactionResponse {
	enum `Type` {
		case Order
		case Withdrawal
	}
	let transactionType: `Type`
	let order: OrderResponse
	let withdrawal: WithdrawalResponse
}
