//
//  Withdrawal.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

struct Withdrawal: Codable {
	enum Status: Codable {
		case Pending
		case Succeeded
		case Failed
	}
	
	let amount: Int
	let withdrawalStatus: Status
	let created: Date
	let completed: Date?
	
	init(withdrawalResponse: WithdrawalResponse) {
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
