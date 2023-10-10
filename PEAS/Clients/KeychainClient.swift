//
//  KeychainClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-18.
//

import Foundation
import SwiftKeychainWrapper

fileprivate enum KeyDefinitions: String, CaseIterable {
	case user
	case business
}

struct KeychainClientKey<T: Codable> {
	let name: String
}

extension KeychainClientKey {
	static var user: KeychainClientKey<User> { .init(name: KeyDefinitions.user.rawValue) }
	static var business: KeychainClientKey<Business> { .init(name: KeyDefinitions.business.rawValue) }
}

protocol KeychainClientProtocol {
	func get<Data: Codable>(key: KeychainClientKey<Data>) -> Data?
	func set<Data: Codable>(key: KeychainClientKey<Data>, value: Data)
	func clearAllKeys()
}

class KeychainClient: KeychainClientProtocol {
	let accessibility: KeychainItemAccessibility = .afterFirstUnlock
	
	static let shared = KeychainClient()
	
	let keychainWrapper: KeychainWrapper
	
	init() {
		self.keychainWrapper = KeychainWrapper(serviceName: "PEAS", accessGroup: "group.com.strikingfinancial.business.PEAS")
	}
	
	func get<Data>(key: KeychainClientKey<Data>) -> Data? where Data : Codable {
		if let data = self.keychainWrapper.data(forKey: KeychainWrapper.Key(rawValue: key.name)) {
			return try? JSONDecoder().decode(Data.self, from: data)
		}
		return nil
	}
	
	func set<Data>(key: KeychainClientKey<Data>, value: Data) where Data : Codable {
		if let data = try? JSONEncoder().encode(value) {
			self.keychainWrapper.set(data, forKey: key.name, withAccessibility: accessibility)
		}
	}
	
	func clearAllKeys() {
		KeyDefinitions.allCases.forEach { key in
			self.keychainWrapper.set("", forKey: key.rawValue, withAccessibility: accessibility)
		}
		self.keychainWrapper.removeAllKeys()
	}
}
