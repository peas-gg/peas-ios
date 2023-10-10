//
//  TransactionsVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation
import SwiftUI

extension TransactionsView {
	@MainActor class ViewModel: ObservableObject {
		@Published var transactionsUnsorted: [Wallet.Transaction]
		
		@Published var currentShowingTransaction: Wallet.Transaction?
		
		var transactions: [Wallet.Transaction] {
			transactionsUnsorted.sorted(by: { $0.date < $1.date })
		}
		
		init(transactions: [Wallet.Transaction]) {
			self.transactionsUnsorted = transactions
		}
		
		func setCurrentShowingTransaction(_ transaction: Wallet.Transaction?) {
			withAnimation(.default) {
				self.currentShowingTransaction = transaction
			}
		}
	}
}
