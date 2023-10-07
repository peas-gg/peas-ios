//
//  Transaction.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct Transaction: Codable {
	enum TransactionType: Codable {
		case Order
		case Withdrawal
	}
	
	let transactionType: TransactionType
	let order: Order?
	let withdrawal: Withdrawal?
}
