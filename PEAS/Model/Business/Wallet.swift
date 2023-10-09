//
//  Wallet.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct Wallet: Codable {
	struct Transaction: Codable {
		struct Earning: Codable {
			let orderId: String
			let title: String
			let base: Int
			let deposit: Int
			let tip: Int
			let fee: Int
			let total: Int
			let created: Date
			let completed: Date?
			
			init(earningResponse: WalletResponse.TransactionResponse.EarningResponse) {
				self.orderId = earningResponse.orderId
				self.title = earningResponse.title
				self.base = earningResponse.base
				self.deposit = earningResponse.deposit
				self.tip = earningResponse.tip
				self.fee = earningResponse.fee
				self.total = earningResponse.total
				self.created = ServerDateFormatter.formatToLocal(from: earningResponse.created)
				self.completed = {
					if let completed = earningResponse.completed {
						return ServerDateFormatter.formatToLocal(from: completed)
					}
					return nil
				}()
			}
		}
		
		struct Withdrawal: Codable {
			enum Status: String, Codable {
				case Pending
				case Succeeded
				case Failed
			}
			
			let amount: Int
			let withdrawalStatus: Status
			let created: Date
			let completed: Date?
			
			init(withdrawalResponse: WalletResponse.TransactionResponse.WithdrawalResponse) {
				self.amount = withdrawalResponse.amount
				self.withdrawalStatus = withdrawalResponse.withdrawalStatus
				self.created = ServerDateFormatter.formatToLocal(from: withdrawalResponse.created)
				self.completed = {
					if let completed = withdrawalResponse.completed {
						return ServerDateFormatter.formatToLocal(from: completed)
					}
					return nil
				}()
			}
		}
		
		enum Info: Codable {
			case earning(Earning)
			case withdrawal(Withdrawal)
		}
		
		let info: Info
		
		init(transactionResponse: WalletResponse.TransactionResponse) throws {
			switch transactionResponse.transactionType {
			case .Earning:
				if let earning = transactionResponse.earning {
					self.info = .earning(Earning(earningResponse: earning))
				} else {
					throw AppError.APIClientError.decodingError
				}
			case .Withdrawal:
				if let withdrawal = transactionResponse.withdrawal {
					self.info = .withdrawal(Withdrawal(withdrawalResponse: withdrawal))
				} else {
					throw AppError.APIClientError.decodingError
				}
			}
		}
	}
	
	let balance: Int64
	let holdBalance: Int64
	let transactions: [Transaction]
	
	init(walletResponse: WalletResponse) {
		self.balance = walletResponse.balance
		self.holdBalance = walletResponse.holdBalance
		self.transactions = walletResponse.transactions.compactMap({ try? Transaction(transactionResponse: $0) })
	}
}

extension Wallet.Transaction {
	var created: Date {
		switch info {
		case .earning(let earning):
			return earning.created
		case .withdrawal(let withdrawal):
			return withdrawal.created
		}
	}
}

extension Wallet {
	static var mock1: Self {
		return Wallet(
			walletResponse: WalletResponse(
				balance: 10000,
				holdBalance: 800,
				transactions: [
					WalletResponse.TransactionResponse(
						transactionType: .Earning,
						earning: .init(
							orderId: "ABCD-EFG-HIJKLM-NOPQRS",
							title: "Box braids",
							base: 10000,
							deposit: 0,
							tip: 3000,
							fee: 800,
							total: 12200,
							created: "2023-09-22T07:10:00Z",
							completed: "2023-09-22T07:10:00Z"
						),
						withdrawal: nil
					),
					WalletResponse.TransactionResponse(
						transactionType: .Withdrawal,
						earning: nil,
						withdrawal: .init(
							amount: 200000,
							withdrawalStatus: .Succeeded,
							created: "2023-09-22T07:10:00Z",
							completed: "2023-09-22T010:10:00Z"
						)
					)
				]
			)
		)
	}
}
