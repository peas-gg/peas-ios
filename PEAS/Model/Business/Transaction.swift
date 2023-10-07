//
//  Transaction.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct Transaction: Codable {
	enum Info: Codable {
		case order(Order)
		case withdrawal(Withdrawal)
	}
	
	let info: Info
	
	init(transactionResponse: TransactionResponse) throws {
		switch transactionResponse.transactionType {
		case .Order:
			if let order = transactionResponse.order {
				self.info = .order(Order(orderResponse: order))
			}
			throw AppError.APIClientError.decodingError
		case .Withdrawal:
			if let withdrawal = transactionResponse.withdrawal {
				self.info = .withdrawal(Withdrawal(withdrawalResponse: withdrawal))
			}
			throw AppError.APIClientError.decodingError
		}
	}
}

extension Transaction {
	var created: Date {
		switch info {
		case .order(let order):
			return order.created
		case .withdrawal(let withdrawal):
			return withdrawal.created
		}
	}
}
