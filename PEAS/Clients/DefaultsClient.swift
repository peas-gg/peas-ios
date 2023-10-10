//
//  DefaultsClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-22.
//

import Foundation
import IdentifiedCollections

fileprivate enum KeyDefinitions: String, CaseIterable {
	case cacheTracker
	case serverUrl
}

protocol DefaultsClientProtocol {
	func get<Data: Codable>(key: DefaultsKey<Data>) -> Data?
	func set<Data: Codable>(key: DefaultsKey<Data>, value: Data)
	func clear()
}

struct DefaultsKey<T: Codable> {
	let name: String
}

extension DefaultsKey {
	static var cacheTracker: DefaultsKey<IdentifiedArrayOf<CacheTrimmer.CacheTracker>> { .init(name: KeyDefinitions.cacheTracker.rawValue) }
	static var server: DefaultsKey<ServerUrl.Server> { .init(name: KeyDefinitions.serverUrl.rawValue) }
}

class DefaultsClient: DefaultsClientProtocol {
	static let shared: DefaultsClient = DefaultsClient()
	
	private let encoder: JSONEncoder = JSONEncoder()
	private let decoder: JSONDecoder = JSONDecoder()
	private let defaults: UserDefaults = UserDefaults(suiteName: "group.com.strikingfinancial.business.PEAS")!
	
	func get<Data>(key: DefaultsKey<Data>) -> Data? where Data : Codable {
		guard let dataObject = defaults.object(forKey: key.name) as? Foundation.Data else { return nil }
		return try? self.decoder.decode(Data.self, from: dataObject)
	}
	
	func set<Data>(key: DefaultsKey<Data>, value: Data) where Data : Codable {
		let encodedData = try? self.encoder.encode(value)
		defaults.set(encodedData, forKey: key.name)
	}
	
	func clear() {
		KeyDefinitions.allCases.forEach { key in
			defaults.removeObject(forKey: key.rawValue)
		}
	}
}
