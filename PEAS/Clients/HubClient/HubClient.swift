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
		Task {
			try? await Task.sleep(for: .seconds(2))
			if await AppState.shared.isUserLoggedIn {
				connection = HubConnectionBuilder(url: URL(string: "https://\(ServerUrl.shared.server.domain)/appHub")!)
					.withLogging(minLogLevel: .error)
					.withHubConnectionDelegate(delegate: self)
					.withAutoReconnect()
					.build()
				
				//Register for Events
				connection?.on(method: "CouldNotSubscribe", callback: {
					self.subscribeForUpdates()
				})
				
				connection?.on(method: "OrderReceived", callback: { (message: String) in
					self.showAppNotification(message: message, sound: "")
				})
				
				connection?.on(method: "PaymentReceived") { (message: String) in
					self.showAppNotification(message: message, sound: "")
				}
				connection?.start()
			}
		}
	}
	
	func stopConnection() {
		self.unsubscribe()
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
		if let userId = KeychainClient.shared.get(key: .user)?.id {
			self.connection?.invoke(method: "Subscribe", userId) { _ in }
		}
	}
	
	func unsubscribe() {
		if let userId = KeychainClient.shared.get(key: .user)?.id {
			self.connection?.invoke(method: "UnSubscribe", userId) { _ in }
		}
	}
	
	private func showAppNotification(message: String, sound: String) {
		Task {
			Task {
				await AppState.shared.showNotification(message: message, sound: sound)
			}
		}
	}
}