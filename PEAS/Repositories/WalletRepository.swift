//
//  WalletRepository.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-07.
//

import Foundation

@MainActor class WalletRepository: ObservableObject {
	static let shared: WalletRepository = WalletRepository()
	
	@Published var wallet: Wallet
	
	//Clients
	private let cacheClient: CacheClient = CacheClient.shared
	
	init() {
		self.wallet = Wallet(
			walletResponse: WalletResponse(
				balance: 0,
				holdBalance: 0,
				transactions: []
			)
		)
		setUp()
	}
	
	func update(wallet: Wallet) {
		self.wallet = wallet
		update()
	}
	
	private func setUp() {
		Task {
			if let wallet = await cacheClient.getData(key: .wallet) {
				self.wallet = wallet
			}
		}
	}
	
	private func update() {
		Task {
			await cacheClient.setData(key: .wallet, value: self.wallet)
		}
	}
}
