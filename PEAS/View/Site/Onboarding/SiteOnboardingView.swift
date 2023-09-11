//
//  SiteOnboardingView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import SwiftUI
import IdentifiedCollections

struct SiteOnboardingView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		VStack {
			if let businessDraft = viewModel.businessDraft {
				VStack {
					SiteView(viewModel: SiteView.ViewModel(isTemplate: true, business: businessDraft))
					Spacer()
					VStack {
						Button(action: { viewModel.showResetWarning() }) {
							Image(systemName: "arrow.counterclockwise")
							Text("Reset")
						}
						.font(Font.app.title3)
						.foregroundColor(Color.app.tertiaryText)
						Button(action: { viewModel.proceed() }) {
							Text(viewModel.isUserLoggedIn ? "Publish" : "Create")
						}
						.buttonStyle(.expanded(style: .black))
					}
					.padding(.top, 8)
				}
				.transition(
					.asymmetric(
						insertion: .scale,
						removal: .identity
					)
				)
				.animation(.easeIn, value: viewModel.businessDraft)
			} else {
				VStack {
					let padding: CGFloat = 10
					SymmetricHStack(
						content: {
							Text("What is your art?")
								.font(Font.app.title2)
								.foregroundColor(Color.app.primaryText)
						},
						leading: { EmptyView() },
						trailing: {
							Button(action: { viewModel.backToWelcomeScreen() }) {
								Text("Cancel")
									.font(.system(size: FontSizes.title3, weight: .regular, design: .rounded))
									.foregroundColor(Color.app.primaryText.opacity(0.8))
							}
						}
					)
					.padding(.horizontal)
					Text("Select your art to start setting up your business site")
						.font(Font.app.body)
						.multilineTextAlignment(.leading)
						.padding(.top, padding)
					ZStack {
						Color.clear
							.progressView(isShowing: viewModel.isLoading, style: .black, coverOpacity: 0.0)
							.opacity(viewModel.isLoading ? 1.0 : 0.0)
							.transition(
								.asymmetric(
									insertion: .opacity.animation(.easeIn.delay(0.1)),
									removal: .identity
								)
							)
						VStack {
							ScrollView(showsIndicators: false) {
								LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
									ForEach(viewModel.templates) { template in
										templateView(template)
											.transition(.scale)
									}
								}
								.padding(.top, padding)
							}
						}
						.padding(.horizontal, padding)
						.animation(.spring(dampingFraction: 1.22), value: viewModel.templates)
					}
				}
			}
		}
		.confirmationDialog(
			"",
			isPresented: $viewModel.isShowingResetWarning,
			actions: {
				Button("Reset", role: .destructive) {
					viewModel.resetBusinessDraft()
				}
			},
			message: {
				Text("Are you sure? Please note you will lose all of your progress")
			}
		)
		.transition(
			.asymmetric(
				insertion: .push(from: .bottom),
				removal: .move(edge: .bottom)
			)
		)
		.sheet(
			isPresented: Binding(
				get: { viewModel.isShowingAuthenticateView },
				set: { _ in }
			)
		) {
			AuthenticateView(
				viewModel: .init(context: .signUp(.nameAndTerms)),
				dismiss: { viewModel.setIsShowingAuthenticateView(false) }
			)
		}
		.onAppear {
			UIScrollView.appearance().bounces = true
			viewModel.refreshTemplates()
		}
		.onChange(of: viewModel.isShowingAuthenticateView) { isShowing in
			if !isShowing {
				KeyboardClient.shared.resignKeyboard()
			}
		}
	}
	
	@ViewBuilder
	func templateView(_ template: Template) -> some View {
		Button(action: { viewModel.selectTemplate(template) }) {
			CachedImage(
				url: template.photo,
				content: { uiImage in
					Image(uiImage: uiImage)
						.resizable()
						.aspectRatio(contentMode: .fit)
				},
				placeHolder: {
					Color.gray
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
		SiteOnboardingView(viewModel: .init())
	}
}

struct SiteOnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			SiteOnboardingView(viewModel: .init())
		}
	}
}
