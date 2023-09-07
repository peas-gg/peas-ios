//
//  KeychainClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-18.
//

import Foundation
import SwiftKeychainWrapper

fileprivate enum KeyDefinitions: String, CaseIterable {
	case token
	case user
	case business
}

struct KeychainClientKey<T: Codable> {
	let name: String
}

extension KeychainClientKey {
	static var token: KeychainClientKey<Token> { .init(name: KeyDefinitions.token.rawValue) }
	static var user: KeychainClientKey<User> { .init(name: KeyDefinitions.user.rawValue) }
	static var business: KeychainClientKey<Business> { .init(name: KeyDefinitions.user.rawValue) }
}

protocol KeychainClientProtocol {
	func get<Data: Codable>(key: KeychainClientKey<Data>) -> Data?
	func set<Data: Codable>(key: KeychainClientKey<Data>, value: Data)
	func clearAllKeys()
}

class KeychainClient: KeychainClientProtocol {
	let accessibility: KeychainItemAccessibility = .afterFirstUnlock
	
	static let shared = KeychainClient()
	
	func get<Data>(key: KeychainClientKey<Data>) -> Data? where Data : Codable {
		if let data = KeychainWrapper.standard.data(forKey: KeychainWrapper.Key(rawValue: key.name)) {
			return try? JSONDecoder().decode(Data.self, from: data)
		}
		return nil
	}
	
	func set<Data>(key: KeychainClientKey<Data>, value: Data) where Data : Codable {
		if let data = try? JSONEncoder().encode(value) {
			KeychainWrapper.standard.set(data, forKey: key.name, withAccessibility: accessibility)
		}
	}
	
	func clearAllKeys() {
		KeyDefinitions.allCases.forEach { key in
			KeychainWrapper.standard.set("", forKey: key.rawValue, withAccessibility: accessibility)
		}
		KeychainWrapper.standard.removeAllKeys()
	}
}
