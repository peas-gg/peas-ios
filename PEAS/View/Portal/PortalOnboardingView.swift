//
//  PortalOnboardingView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import SwiftUI

struct PortalOnboardingView: View {
	var body: some View {
		VStack {
			VStack {
				Text("Select your art to start setting up your business profile")
					.font(Font.app.body)
					.multilineTextAlignment(.leading)
				Spacer()
				
				ScrollView(showsIndicators: false) {
					LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
						ForEach(0..<10, id: \.self) { index in
							Button(action: {}) {
								RoundedRectangle(cornerRadius: 20)
									.frame(height: 170)
							}
						}
					}
				}
				.padding(.top, 20)
			}
			.padding(.horizontal, 10)
		}
	}
}

fileprivate struct TestView: View {
	var body: some View {
		NavigationStack {
			NavigationLink(
				destination: {
				PortalOnboardingView()
			} ) {
				Text("Tap Me")
					.padding()
					.background(Color.app.accent)
					.cornerRadius(20)
			}
		}
	}
}

struct PortalOnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		TestView()
	}
}
