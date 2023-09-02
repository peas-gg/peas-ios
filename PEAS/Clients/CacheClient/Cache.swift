//
//  Cache.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-22.
//

import CryptoKit
import Foundation

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
}
