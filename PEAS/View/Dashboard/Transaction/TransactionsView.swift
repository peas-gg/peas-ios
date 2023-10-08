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
		VStack {
			VStack {
				Spacer()
					.frame(height: 40)
				ScrollView {
					LazyVStack {
						ForEach(viewModel.transactions.indices, id: \.self) { index in
							transactionView(viewModel.transactions[index])
								.padding(.bottom, 10)
						}
					}
					.padding()
				}
				.background {
					Color.app.primaryBackground
						.cornerRadius(10, corners: [.topLeft, .topRight])
				}
				.edgesIgnoringSafeArea(.bottom)
			}
			.padding(.horizontal)
		}
		.background(Color.app.secondaryBackground)
	}
	
	@ViewBuilder
	func transactionView(_ transaction: Wallet.Transaction) -> some View {
		HStack {
			VStack(alignment: .leading, spacing: 4) {
				title(transaction: transaction)
				subTitle(transaction: transaction)
				Text(transaction.created, style: .date)
					.font(Font.app.callout)
					.foregroundStyle(Color.app.primaryText.opacity(0.8))
			}
			Spacer(minLength: 0)
			amount(transaction: transaction)
		}
	}
	
	@ViewBuilder
	func title(transaction: Wallet.Transaction) -> some View {
		let content: String = {
			switch transaction.info {
			case .earning(let earning):
				return earning.title
			case .withdrawal:
				return "CashOut"
			}
		}()
		Text(content)
			.font(Font.app.bodySemiBold)
			.foregroundStyle(Color.app.primaryText)
			.lineLimit(1)
	}
	
	@ViewBuilder
	func subTitle(transaction: Wallet.Transaction) -> some View {
		let content: String = {
			switch transaction.info {
			case .earning(let earning):
				return "#\(String(earning.orderId.prefix(5)))"
			case .withdrawal(let withdrawal):
				return "CashOut \(withdrawal.withdrawalStatus)"
			}
		}()
		Text(content)
			.font(Font.app.body)
			.foregroundStyle(Color.app.tertiaryText)
			.lineLimit(1)
	}
	
	@ViewBuilder
	func amount(transaction: Wallet.Transaction) -> some View {
		let amount: Int = {
			switch transaction.info {
			case .earning(let earning):
				return earning.total
			case .withdrawal(let withdrawal):
				return withdrawal.amount
			}
		}()
		
		let amountSign: String = {
			switch transaction.info {
			case .earning:
				return ""
			case .withdrawal:
				return "-"
			}
		}()
		
		let amountString: String = "\(amountSign)$\(PriceFormatter.price(value: String(amount)))"
		
		let foregroundColor: Color = {
			switch transaction.info {
			case .earning:
				return Color.app.approvedText
			case .withdrawal:
				return Color.app.completedText
			}
		}()
		
		let backgroundColor: Color = {
			switch transaction.info {
			case .earning:
				return Color.app.approvedBackground
			case .withdrawal:
				return Color.app.completedBackground
			}
		}()
		
		Text(amountString)
			.font(Font.app.body)
			.foregroundStyle(foregroundColor)
			.padding(4)
			.padding(.horizontal, 6)
			.background(backgroundColor)
			.cornerRadius(5)
	}
}

#Preview("Transactions") {
	TransactionsView(viewModel: .init(transactions: Wallet.mock1.transactions))
}
