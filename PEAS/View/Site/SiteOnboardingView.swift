//
//  SiteOnboardingView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import SwiftUI
import IdentifiedCollections

struct SiteOnboardingView: View {
	let templates: IdentifiedArrayOf<Template>
	var body: some View {
		VStack {
			Text("What is your art?")
				.font(Font.app.title2)
				.foregroundColor(Color.app.primaryText)
			Text("Select your art to start setting up your business site")
				.font(Font.app.body)
				.multilineTextAlignment(.leading)
				.padding(.top, 10)
			VStack {
				ScrollView(showsIndicators: false) {
					LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
						ForEach(templates) { template in
							templateView(template)
						}
					}
					.padding(.top, 10)
				}
			}
			.padding(.horizontal, 10)
		}
	}
	
	@ViewBuilder
	func templateView(_ template: Template) -> some View {
		Button(action: {}) {
			CachedImage(
				url: template.photo,
				content: { uiImage in
					Image(uiImage: uiImage)
						.resizable()
						.aspectRatio(contentMode: .fit)
				},
				placeHolder: {
					Color.gray
						.overlay(ProgressView())
				}
			)
			.clipShape(RoundedRectangle(cornerRadius: 20))
			.frame(minHeight: 170)
			.overlay(
				RoundedRectangle(cornerRadius: 20)
					.fill(
						LinearGradient(
							colors: [Color.black.opacity(0.1), Color.black.opacity(0.6)],
							startPoint: .top,
							endPoint: .bottom
						)
					)
					.overlay(
						VStack {
							Text(template.category)
								.font(Font.app.title1)
								.foregroundColor(Color.app.secondaryText)
						}
					)
			)
		}
		.buttonStyle(.insideScaling)
	}
}

fileprivate struct TestView: View {
	var body: some View {
		SiteOnboardingView(templates: [])
	}
}

struct SiteOnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		SiteOnboardingView(templates: [Template.mock1])
	}
}
