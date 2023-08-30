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
		switch appState.mode {
		case .welcome:
			Text("WELCOME")
		case .template:
			SiteView(viewModel: .init(isTemplate: true, business: Business.mock1))
		case .home:
			HomeView(viewModel: .init())
		}
	}
}

struct AppView_Previews: PreviewProvider {
	static var previews: some View {
		AppView()
	}
}
