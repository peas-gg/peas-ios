//
//  PEASApp.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

@main
struct PEASApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	@Environment(\.scenePhase) var scenePhase
	
	//Clients
	private var hubClient: HubClient = HubClient.shared
	
	var body: some Scene {
		WindowGroup {
			AppView()
				.onAppear {
					if let keyWindow = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) {
						keyWindow.overrideUserInterfaceStyle = .light
					}
				}
		}
		.onChange(of: scenePhase) { newPhase in
			switch newPhase {
			case .active:
				NotificationCenter.default.post(Notification(name: .refreshApp, userInfo: [:]))
				self.hubClient.initializeConnection()
			case .inactive:
				return
			case .background:
				self.hubClient.stopConnection()
			@unknown default:
				return
			}
		}
	}
}
