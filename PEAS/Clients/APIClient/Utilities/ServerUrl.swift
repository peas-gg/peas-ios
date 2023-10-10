//
//  ServerUrl.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-09.
//

import Foundation

class ServerUrl {
	static var shared: ServerUrl = ServerUrl()
	
	enum Server: Codable {
		case development
		case production
		
		var domain: String {
			switch self {
			case .development: return "peasapidev.azurewebsites.net"
			case .production: return "peasapi.azurewebsites.net"
			}
		}
	}
	
	var server: Server
	
	init() {
		if let serverInDefaults = DefaultsClient.shared.get(key: .server) {
			self.server = serverInDefaults
		} else {
#if DEBUG
		self.server = .development
#else
		self.server = .production
#endif
		}
	}
	
	func setServer(_ server: Server) {
		self.server = server
	}
}
