//
//  Wallet.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct Wallet: Codable {
	let balance: Int64
	let holdBalance: Int64
	let transactions: [Transaction]
	
	init(walletResponse: WalletResponse) {
		self.balance = walletResponse.balance
		self.holdBalance = walletResponse.holdBalance
		self.transactions = walletResponse.transactions.compactMap({ try? Transaction(transactionResponse: $0) })
	}
}
