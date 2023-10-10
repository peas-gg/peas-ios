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
					.frame(height: 20)
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
		.overlay(isShown: viewModel.currentShowingTransaction != nil) {
			Color.black.opacity(0.2)
				.ignoresSafeArea()
				.transition(.opacity)
				.onTapGesture { viewModel.setCurrentShowingTransaction(nil) }
				.overlay {
					if let currentShowingTransaction = viewModel.currentShowingTransaction {
						amountDetailView(transaction: currentShowingTransaction)
					}
				}
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Transactions")
					.font(Font.app.title2)
					.foregroundStyle(Color.app.primaryText)
			}
		}
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
		
		Button(action: { viewModel.setCurrentShowingTransaction(transaction) }) {
			Text(amountString)
				.font(Font.app.body)
				.foregroundStyle(foregroundColor)
				.padding(4)
				.padding(.horizontal, 6)
				.background(backgroundColor)
				.cornerRadius(5)
		}
	}
	
	@ViewBuilder
	func amountDetailView(transaction: Wallet.Transaction) -> some View {
		VStack {
			VStack(spacing: 20) {
				SymmetricHStack(
					content: {
						Text("Summary")
							.font(Font.app.title2)
					},
					leading: {
						Button(action: { viewModel.setCurrentShowingTransaction(nil) }) {
							Image(systemName: "xmark")
								.font(.system(size: 24))
						}
					},
					trailing: { EmptyView() }
				)
				.foregroundStyle(Color.app.primaryText)
				.padding(.bottom, 10)
				switch transaction.info {
				case .earning(let earning):
					VStack(spacing: 10) {
						HStack {
							VStack(alignment: .leading) {
								amountDetailLabel("Price: ")
								Text("(\(earning.title))")
									.font(Font.app.footnote)
									.foregroundStyle(Color.app.tertiaryText)
							}
							Spacer()
							amountDetailPrice(getFormattedPrice(price: earning.base))
						}
						HStack {
							amountDetailLabel("Tip: ")
							Spacer()
							amountDetailPrice(getFormattedPrice(price: earning.tip))
						}
						HStack {
							amountDetailLabel("Service fee: ")
							Spacer()
							amountDetailPrice(getFeePercentage(earning: earning))
						}
						HStack {
							amountDetailLabel("Total:")
							Spacer()
							amountDetailPrice(getFormattedPrice(price: earning.total), isTotal: true)
						}
					}
				case .withdrawal(let withdrawal):
					HStack {
						VStack {
							amountDetailLabel("CashOut: ")
							Text("(\(withdrawal.withdrawalStatus.rawValue.lowercased()))")
								.font(Font.app.callout)
								.foregroundStyle(Color.app.tertiaryText)
						}
						Spacer()
						amountDetailPrice("-\(getFormattedPrice(price: withdrawal.amount))")
					}
				}
			}
			.padding()
			.padding(.horizontal)
		}
		.background(CardBackground(cornerRadius: 20))
		.padding(.horizontal, 40)
	}
	
	@ViewBuilder
	func amountDetailLabel(_ content: String) -> some View {
		Text(content)
			.font(Font.app.body)
	}
	
	@ViewBuilder
	func amountDetailPrice(_ content: String, isTotal: Bool = false) -> some View {
		Text(content)
			.font(Font.app.bodySemiBold)
			.foregroundStyle(isTotal ? Color.green : Color.app.primaryText)
	}
	
	func getFormattedPrice(price: Int) -> String {
		return "$\(PriceFormatter.price(value: String(price)))"
	}
	
	func getFeePercentage(earning: Wallet.Transaction.Earning) -> String {
		let feePercentage = Double(earning.fee) / Double(earning.total) * 100.0
		let feePercentageString = String(format: "%.2f", feePercentage)
		return "\(feePercentageString)%"
	}
}

#Preview("Transactions") {
	VStack {
		TransactionsView(viewModel: .init(transactions: Wallet.mock1.transactions))
	}
}
