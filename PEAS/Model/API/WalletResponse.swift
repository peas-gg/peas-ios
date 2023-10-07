//
//  WalletResponse.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct WalletResponse: Decodable {
	struct TransactionResponse: Decodable {
		struct EarningResponse: Decodable {
			let orderId: String
			let title: String
			let base: Int
			let deposit: Int
			let tip: Int
			let fee: Int
			let total: Int
			let created: String
			let completed: String?
		}
		
		struct WithdrawalResponse: Decodable {
			let amount: Int
			let withdrawalStatus: Wallet.Transaction.Withdrawal.Status
			let created: String
			let completed: String?
		}
		
		enum TransactionType: Decodable {
			case Earning
			case Withdrawal
		}
		
		let transactionType: TransactionType
		let earning: EarningResponse?
		let withdrawal: WithdrawalResponse?
	}
	
	let balance: Int64
	let holdBalance: Int64
	let transactions: [TransactionResponse]
}
