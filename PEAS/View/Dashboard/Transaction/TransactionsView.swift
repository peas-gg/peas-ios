//
//  TransactionsView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import SwiftUI

struct TransactionsView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Text("Hello, World!")
	}
}

#Preview("Transactions") {
	TransactionsView(viewModel: .init(transactions: Wallet.mock1.transactions))
}
