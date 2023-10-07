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
}
