//
//  WelcomeVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import Foundation

extension WelcomeView {
	@MainActor class ViewModel: ObservableObject {
		let onboardingVM: SiteOnboardingView.ViewModel
		
		init(onboardingVM: SiteOnboardingView.ViewModel) {
			self.onboardingVM = onboardingVM
		}
		
		func startOnboarding() {
			AppState.updateAppState(with: .changeAppMode(.onboarding(onboardingVM)))
		}
	}
}
