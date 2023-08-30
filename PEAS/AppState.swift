//
//  AppState.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-24.
//

import Foundation

@MainActor class AppState: ObservableObject {
	enum AppMode {
		case welcome
		case onboarding
		case home
	}
	
	@Published var mode: AppMode = .welcome
	
	func setAppMode(_ mode: AppMode) {
		self.mode = mode
	}
}
