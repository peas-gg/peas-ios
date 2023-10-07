//
//  TransactionResponse.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct TransactionResponse: Decodable {
	enum TransactionType: Decodable {
		case Order
		case Withdrawal
	}
	let transactionType: TransactionType
	let order: OrderResponse?
	let withdrawal: WithdrawalResponse?
}
