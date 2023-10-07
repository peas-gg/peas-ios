//
//  TransactionsVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

extension TransactionsView {
	@MainActor class ViewModel: ObservableObject {
		@Published var transactionsUnsorted: [Wallet.Transaction]
		
		var transactions: [Wallet.Transaction] {
			transactionsUnsorted.sorted(by: { $0.created < $1.created })
		}
		
		init(transactions: [Wallet.Transaction]) {
			self.transactionsUnsorted = transactions
		}
	}
}
