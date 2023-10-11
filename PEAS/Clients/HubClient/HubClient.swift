//
//  HubClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-10.
//

import Foundation

import SignalRClient

class HubClient: HubConnectionDelegate {
	static let shared: HubClient = HubClient()
	
	private var connection: HubConnection?
	
	init() {
		initializeConnection()
	}
	
	func initializeConnection() {
		self.connection = nil
		connection = HubConnectionBuilder(url: URL(string: "https://\(ServerUrl.shared.server.domain)/appHub")!)
			.withLogging(minLogLevel: .error)
			.withHttpConnectionOptions(configureHttpOptions: { httpConnectionOptions in
				httpConnectionOptions.accessTokenProvider = { KeychainClient.shared.get(key: .user)?.accessToken }
			})
			.withHubConnectionDelegate(delegate: self)
			.withAutoReconnect()
			.build()
		
		//Register for Events
		connection?.on(method: "UnAuthorized", callback: {
			self.subscribeForUpdates()
		})

		connection?.on(method: "OrderReceived", callback: { (message: String) in
			//Update Orders
		})
		
		connection?.on(method: "PaymentReceived") { (message: String) in
			//Update Wallet
		}
		connection?.start()
	}
	
	func stopConnection() {
		self.connection?.stop()
	}
	
	internal func connectionDidOpen(hubConnection: SignalRClient.HubConnection) {
		self.subscribeForUpdates()
	}
	
	internal func connectionDidFailToOpen(error: Error) {
		self.initializeConnection()
	}
	
	internal func connectionDidClose(error: Error?) {
		return
	}
	
	func subscribeForUpdates() {
		self.connection?.invoke(method: "Subscribe") { _ in }
	}
}
