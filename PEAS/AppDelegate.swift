//
//  AppDelegate.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-02.
//
import Combine
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
	
	private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
	
	override init() {
		super.init()
	}
	
	func application(
		_ application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
	) {
		let token: String = deviceToken.hexString
		APIClient
			.shared
			.addDevice(token)
			.sink(
				receiveCompletion: { _ in },
				receiveValue: { _ in }
			)
			.store(in: &cancellableBag)
	}
}
