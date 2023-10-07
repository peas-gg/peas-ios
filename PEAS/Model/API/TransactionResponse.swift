//
//  TransactionResponse.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct TransactionResponse: Decodable {
	let transactionType: Transaction.TransactionType
	let order: OrderResponse
	let withdrawal: WithdrawalResponse
}
