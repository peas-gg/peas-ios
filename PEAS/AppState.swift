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
		case welcome(WelcomeView.ViewModel)
		case onboarding(SiteOnboardingView.ViewModel)
		case home(HomeView.ViewModel)
	}
	
	enum AppAction {
		case changeAppMode(AppMode)
	}
	
	@Published var mode: AppMode?
	
	//Clients
	let cacheClient = CacheClient.shared
	
	init() {
		Task(priority: .high) {
			let businessDraft = await cacheClient.getData(key: .businessDraft)
			let onboardingVM = SiteOnboardingView.ViewModel(draft: businessDraft)
			
			if businessDraft != nil {
				self.mode = .onboarding(onboardingVM)
			} else {
				self.mode = .welcome(WelcomeView.ViewModel(onboardingVM: onboardingVM))
			}
		}
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
