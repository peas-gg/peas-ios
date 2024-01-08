//
//  Cache.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-22.
//

import CryptoKit
import Foundation
import IdentifiedCollections

struct Cache: Identifiable {
	let key: String
	let object: Codable
	
	var id: String { key }
}

struct CacheKey<Object: Codable> {
	let name: String
}

extension CacheKey {
	static var businessDraft: CacheKey<Business> { .init(name: "businessDraft") }
	static var customers: CacheKey<IdentifiedArrayOf<Customer>> { .init(name: "customers") }
	static var orders: CacheKey<IdentifiedArrayOf<Order>> { .init(name: "orders") }
	static var timeBlocks: CacheKey<IdentifiedArrayOf<TimeBlock>> { .init(name: "timeBlocks") }
	static var wallet: CacheKey<Wallet> { .init(name: "wallet") }
}
