//
//  CashOutView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-24.
//

import SwiftUI

struct CashOutView: View {
	@StateObject var viewModel: ViewModel
	
	let pageTitle: String = "CashOut"
	
	var body: some View {
		switch viewModel.context {
		case .onboarding:
			VStack(spacing: 0) {
				SymmetricHStack(
					content: {
						Text(pageTitle)
							.font(Font.app.title2Display)
					},
					leading: {
						EmptyView()
					},
					trailing: {
						Button(action: {}) {
							Text("Done")
								.font(.system(size: FontSizes.title3))
								.padding()
						}
					}
				)
				Divider()
					.padding(.top, 10)
				VStack {
					VStack(spacing: 20) {
						HStack(spacing: 10) {
							Spacer()
							Image("SiteLogo")
								.resizable()
								.scaledToFit()
								.frame(dimension: 60)
							Text("🤝")
								.font(.system(size: 40))
							Image("InteracLogo")
								.resizable()
								.scaledToFit()
								.frame(dimension: 54)
							Spacer()
						}
						.padding(.top)
						Text("Your earnings will be deposited via interac. Set your interac email to cash out")
							.font(Font.app.subHeader)
							.multilineTextAlignment(.leading)
						VStack(spacing: 2) {
							label("Use account email")
							emailSelectionView(selection: .account)
						}
						VStack(spacing: 2) {
							label("Use a different email")
							emailSelectionView(selection: .different)
						}
					}
					.padding(.horizontal)
					Spacer(minLength: 0)
				}
				.background(Color.app.secondaryBackground)
			}
			.foregroundColor(Color.app.primaryText)
			.background(Color.app.primaryBackground)
		case .cashOut:
			EmptyView()
		}
	}
	
	@ViewBuilder
	func label(_ content: String) -> some View {
		HStack {
			Text(content)
				.font(Font.app.body)
				.foregroundColor(Color.app.tertiaryText)
			Spacer()
		}
		.padding(.horizontal)
	}
	
	@ViewBuilder
	func emailSelectionView(selection: ViewModel.EmailSelection) -> some View {
		let isCurrentSelection: Bool = selection == viewModel.currentEmailSelection
		HStack {
			Group {
				switch selection {
				case .account:
					Text(viewModel.user.email)
				case .different:
					TextField("", text: $viewModel.differentEmail)
						.autocorrectionDisabled()
				}
			}
			.font(Font.app.title3)
			.foregroundColor(isCurrentSelection ? Color.app.primaryText : Color.app.tertiaryText)
			.lineLimit(1)
			Spacer(minLength: 30)
		}
		.padding()
		.background(CardBackground())
		.padding(.horizontal)
		.shadow(color: isCurrentSelection ? Color.black.opacity(0.1) : Color.clear, radius: 10, x: 0, y: 4)
		.overlay(alignment: .trailing) {
			Button(action: { viewModel.selectEmail(selection: selection) }) {
				Group {
					if isCurrentSelection {
						Image(systemName: "checkmark.circle.fill")
							.font(Font.app.title3)
					} else {
						ZStack {
							Circle()
								.fill(Color.white)
							Circle()
								.stroke(Color.gray.opacity(0.6))
						}
						.frame(dimension: 20)
					}
				}
				.padding(.trailing, 30)
			}
		}
		.animation(.easeIn, value: viewModel.currentEmailSelection)
		.onChange(of: viewModel.differentEmail) { email in
			if !email.isValidEmail {
				viewModel.selectEmail(selection: .account)
			}
		}
	}
	
	@ViewBuilder
	func checkMark() -> some View {
		Image(systemName: "checkmark.circle.fill")
			.font(Font.app.title3)
	}
}

struct CashOutView_Previews: PreviewProvider {
	static var previews: some View {
		CashOutView(viewModel: .init(user: User.mock1))
	}
}
