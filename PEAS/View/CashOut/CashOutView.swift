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
	
	@FocusState var isTextFieldFocused: Bool
	
	var onDismiss: () -> ()
	
	var body: some View {
		Group {
			switch viewModel.context {
			case .onboarding:
				VStack(spacing: 0) {
					SymmetricHStack(
						content: {
							Text(pageTitle)
								.font(Font.app.title2Display)
						},
						leading: {
							Button(action: { onDismiss() }) {
								Text("Cancel")
									.font(.system(size: FontSizes.title3))
									.padding()
							}
						},
						trailing: {
							EmptyView()
						}
					)
					Divider()
					VStack {
						VStack(spacing: 10) {
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
							if viewModel.isShowingConfirmation {
								Spacer(minLength: 0)
								Text("Please confirm the email address is correct")
									.multilineTextAlignment(.center)
									.padding(.top)
								Text(viewModel.selectedEmail)
									.font(Font.app.title1)
								Button(action: { viewModel.setIsShowingConfirmation(false) }) {
									Image(systemName: "arrow.left")
									Text("Update email")
										.underline()
								}
								.font(Font.app.body)
								.padding(.vertical)
								Spacer(minLength: 0)
								Spacer(minLength: 0)
							} else {
								Text("Set your interac e-transfer email to cash out your earnings")
									.font(Font.app.subHeader)
									.multilineTextAlignment(.leading)
									.padding(.vertical)
									.fixedSize(horizontal: false, vertical: true)
								VStack(spacing: 2) {
									label("Use account email")
									emailSelectionView(selection: .account)
								}
								VStack(spacing: 2) {
									label("Use a different email")
									emailSelectionView(selection: .different)
										.focused($isTextFieldFocused)
								}
							}
						}
						.padding(.horizontal)
						Spacer(minLength: 0)
						Button(action: { viewModel.advance() }) {
							Text(viewModel.isShowingConfirmation ? "Looks good 👍" : "Next")
						}
						.buttonStyle(.expanded)
						.padding([.horizontal, .bottom])
					}
					.background(Color.app.secondaryBackground)
				}
				.foregroundColor(Color.app.primaryText)
				.background(Color.app.primaryBackground)
				.progressView(isShowing: viewModel.isLoading, style: .white)
			case .cashOut:
				VStack {
					SymmetricHStack(
						content: {
							Text(pageTitle)
								.font(Font.app.title2Display)
								.foregroundColor(Color.app.darkGreen)
						},
						leading: {
							Button(action: { onDismiss() }) {
								Image(systemName: "xmark")
									.font(.system(size: FontSizes.title2))
									.fontWeight(.bold)
									.foregroundColor(Color.app.darkGreen)
									.padding()
							}
						},
						trailing: {
							EmptyView()
						}
					)
					VStack(spacing: 20) {
						VStack {
							let wallet: Wallet = viewModel.wallet
							let balanceString: String = PriceFormatter.price(value: String(wallet.balance - wallet.holdBalance))
							let holdBalanceString: String = PriceFormatter.price(value: String(wallet.holdBalance))
							let fontSize: CGFloat = balanceString.count > 8 ? 40 : 50
							Text("$\(balanceString)")
								.foregroundColor(Color.app.secondaryText)
								.font(.system(size: fontSize, weight: .semibold, design: .rounded))
							Text("Hold: $\(holdBalanceString)")
								.foregroundColor(Color.app.darkGreen)
								.font(Font.app.bodySemiBold)
								.lineLimit(1)
								.opacity(wallet.holdBalance > 0 ? 1.0 : 0.0)
						}
						HStack(spacing: 20) {
							Image("Interac")
								.resizable()
								.scaledToFit()
								.frame(dimension: 50)
							Group {
								Text("Your earnings will be sent to")
								+ Text(" \(viewModel.user.interacEmail ?? "") ")
									.fontWeight(.bold)
								+ Text("using \nInterac e-Transfer")
							}
							.font(Font.app.body)
							.foregroundColor(Color.app.darkGreen)
							Spacer(minLength: 0)
						}
						.padding(.vertical)
						SlidingButtonView(status: $viewModel.slidingButtonStatus)
							.padding(.bottom, 20)
					}
					.padding()
				}
				.pushOutFrame()
				.background(Color.app.accent)
				.presentationDetents([.height(370)])
				.edgesIgnoringSafeArea(.bottom)
				.interactiveDismissDisabled()
			}
		}
		.banner(data: $viewModel.bannerData)
		.onChange(of: viewModel.dismiss) { _ in onDismiss() }
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
			Button(action: {
				viewModel.selectEmail(selection: selection)
				self.isTextFieldFocused = false
			}) {
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
		CashOutView(
			viewModel: .init(
				context: .onboarding,
				user: User.mock1,
				business: Business.mock1,
				wallet: Wallet.mock1
			),
			onDismiss: {}
		)
		CashOutView(
			viewModel: .init(
				context: .cashOut,
				user: User.mock1,
				business: Business.mock1,
				wallet: Wallet.mock1
			),
			onDismiss: {}
		)
	}
}
