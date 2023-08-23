//
//  PortalOnboardingView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import SwiftUI
import IdentifiedCollections

struct PortalOnboardingView: View {
	let templates: IdentifiedArrayOf<Template>
	var body: some View {
		VStack {
			VStack {
				ScrollView(showsIndicators: false) {
					Text("Select your art to start setting up your business profile")
						.font(Font.app.body)
						.multilineTextAlignment(.leading)
						.padding(.vertical, 20)
					LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
						ForEach(templates) { template in
							templateView(template)
						}
					}
				}
			}
			.padding(.horizontal, 10)
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("What is your art?")
					.font(Font.title2)
					.foregroundColor(Color.app.primaryText)
			}
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
		NavigationStack {
			NavigationLink(
				destination: {
				PortalOnboardingView(templates: [])
			} ) {
				Text("Tap Me")
					.padding()
					.background(Color.app.accent)
					.cornerRadius(20)
			}
			.navigationTitle("")
		}
		.tint(Color.app.primaryText)
	}
}

struct PortalOnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		PortalOnboardingView(templates: [Template.mock1])
	}
}
