//
//  WelcomeView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import SwiftUI

struct WelcomeView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Button(action: { viewModel.startOnboarding() }) {
			Text("Start")
		}
	}
}

struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView(viewModel: .init(onboardingVM: .init()))
	}
}
