//
//  AppState.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-24.
//

import Foundation
import SwiftUI

fileprivate let appStateKeyNotification: String = "appState"

@MainActor class AppState: ObservableObject {
	enum AppMode {
		case welcome
		case onboarding(SiteOnboardingView.ViewModel)
		case home
	}
	
	enum AppAction {
		case changeAppMode(AppMode)
	}
	
	@Published var mode: AppMode = .welcome
	
	init() {
		NotificationCenter
			.default.addObserver(
				self,
				selector: #selector(updateAppState),
				name: .updateAppState,
				object: nil
			)
	}
	
	func setAppMode(_ mode: AppMode) {
		withAnimation(.default) {
			self.mode = mode
		}
	}
	
	@objc func updateAppState(notification: NSNotification) {
		if let dict = notification.userInfo as? NSDictionary {
			if let appAction = dict[appStateKeyNotification] as? AppAction {
				switch appAction {
				case .changeAppMode(let appMode):
					setAppMode(appMode)
				}
			}
		}
	}
}

extension AppState {
	static func updateAppState(with action: AppAction) {
		let notification = Notification(name: .updateAppState, userInfo: [appStateKeyNotification: action])
		NotificationCenter.default.post(notification)
	}
}
