//
//  AppView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct AppView: View {
	@StateObject var appState = AppState()
	
	var body: some View {
		let siteOnboardingVM: SiteOnboardingView.ViewModel = SiteOnboardingView.ViewModel()
		switch appState.mode {
		case .welcome:
			Button(action: { appState.setAppMode(.onboarding(siteOnboardingVM)) }) {
				Text("Start")
			}
		case .onboarding:
			SiteOnboardingView(viewModel: siteOnboardingVM)
		case .home:
			HomeView(viewModel: .init())
		}
	}
}

struct AppView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			AppView()
		}
	}
}
