//
//  AppView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct AppView: View {
	@StateObject var appState = AppState.shared
	
	var body: some View {
		Group {
			switch appState.mode {
			case .welcome(let viewModel):
				WelcomeView(viewModel: viewModel)
			case .onboarding(let viewModel):
				SiteOnboardingView(viewModel: viewModel)
			case .home(let viewModel):
				HomeView(viewModel: viewModel)
			case .none:
				Color.black
					.edgesIgnoringSafeArea(.all)
					.progressView(isShowing: true, style: .white)
			}
		}
		.banner(data: $appState.bannerData)
	}
}

struct AppView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			AppView()
		}
	}
}
