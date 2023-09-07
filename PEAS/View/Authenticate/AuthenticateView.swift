//
//  AuthenticateView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import SwiftUI
import iPhoneNumberField
import PhoneNumberKit

struct AuthenticateView: View {
	let verticalStackSpacing: CGFloat = 30.0
	let dismiss: () -> ()
	
	@State var phoneNumber: PhoneNumber?
	@StateObject var viewModel: ViewModel
	
	@FocusState var focusField: ViewModel.FocusField?
	
	init(viewModel: ViewModel, dismiss: @escaping () -> Void) {
		self._viewModel = StateObject(wrappedValue: viewModel)
		self.dismiss = dismiss
	}
	
	var body: some View {
		NavigationStack(path: $viewModel.navStack) {
			contentView(context: viewModel.context, isRootPage: true)
				.navigationTitle("")
				.navigationDestination(for: ViewModel.Context.self) { context in
					contentView(context: context, isRootPage: false)
						.navigationTitle("")
						.navigationBarTitleDisplayMode(.inline)
						.toolbar {
							ToolbarItem(placement: .principal) {
								Text(context.pageTitle)
									.font(Font.app.title2)
									.foregroundColor(Color.white)
							}
						}
				}
		}
		.tint(Color.white)
		.interactiveDismissDisabled()
	}
	
	@ViewBuilder
	func contentView(context: ViewModel.Context, isRootPage: Bool) -> some View {
		VStack(alignment: .leading) {
			if isRootPage {
				SymmetricHStack(
					content: {
						Text(viewModel.context.title)
							.font(Font.app.title2Display)
							.foregroundColor(Color.app.secondaryText)
					},
					leading: { EmptyView() },
					trailing: {
						dismissButton()
							.padding(.trailing)
					}
				)
				.padding(.vertical)
				.background(Color.app.darkGray)
			}
			Spacer()
			Group {
				switch context {
				case .signUp(let flow):
					signUpFlow(flow)
				case .login(let flow):
					loginFlow(flow)
				case .forgotPassword(let flow):
					forgotPasswordFlow(flow)
				}
			}
			.padding(.horizontal, 30)
			Spacer()
			Button(action: {
				if context == .signUp(.phone) {
					self.focusField = nil
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						viewModel.advance(current: context)
					}
				} else {
					viewModel.advance(current: context)
				}
			}) {
				Text(viewModel.advanceButtonTitle(context: context))
			}
			.disabled(!viewModel.canAdvance(context: context))
			.buttonStyle(.expanded(style: .white))
			.padding()
		}
		.background(Color.black)
		.toolbar {
			if !isRootPage {
				ToolbarItem(placement: .navigationBarTrailing) {
					dismissButton()
				}
			}
		}
		.onChange(of: self.phoneNumber) { phone in
			viewModel.updatePhoneNumber(phone)
		}
	}
	
	@ViewBuilder
	func signUpFlow(_ flow: ViewModel.Context.SignUpFlow) -> some View {
		switch flow {
		case .nameAndTerms:
			VStack(spacing: verticalStackSpacing) {
				Spacer(minLength: 0)
				textField(hint: "First name", text: $viewModel.firstName) {
					self.setFocusField(.lastName)
				}
				.focused($focusField, equals: .firstName)
				textField(hint: "Last name", text: $viewModel.lastName) {
					self.focusField = .firstName
				}
				.focused($focusField, equals: .lastName)
				Spacer(minLength: 0)
				VStack(spacing: 2) {
					Text("Already have an account?")
						.font(Font.app.body)
						.foregroundColor(Color.app.tertiaryText)
					Button(action: { viewModel.switchToLoginContext() }) {
						Text("Login")
							.font(Font.app.title2)
							.foregroundColor(Color.app.secondaryText)
							.underline()
					}
				}
				SymmetricHStack(
					content: {
						Group {
							Button(action: {}) {
								Text("Privacy")
									.underline()
							}
							Text("&")
							Button(action: {}) {
								Text("Terms")
									.underline()
							}
						}
						.font(Font.app.title2)
						.foregroundColor(Color.app.tertiaryText)
					},
					leading: {
						Button(action: {}) {
							ZStack {
								RoundedRectangle(cornerRadius: 10)
									.fill(Color.app.darkGray)
								RoundedRectangle(cornerRadius: 10)
									.stroke(Color.white.opacity(0.2), lineWidth: 1)
							}
							.frame(dimension: 36)
						}
						.disabled(true)
						.opacity(0.5)
					},
					trailing: {
						EmptyView()
					}
				)
			}
			.multilineTextAlignment(.leading)
			.onAppear { self.setFocusField(.firstName) }
		case .emailAndPassword:
			VStack(spacing: verticalStackSpacing) {
				VStack {
					textField(hint: "Email", text: $viewModel.email, isEmail: true) {
						self.setFocusField(.password)
					}
					.textContentType(.emailAddress)
					.keyboardType(.emailAddress)
					.focused($focusField, equals: .email)
					Rectangle()
						.fill(Color.app.darkGray)
						.frame(height: 1)
				}
				setPasswordView()
					.textContentType(.password)
			}
			.onAppear { self.setFocusField(.email) }
		case .phone:
			VStack(spacing: verticalStackSpacing + 10) {
				HStack {
					iPhoneNumberField(text: $viewModel.phone) { field in
						DispatchQueue.main.async {
							self.phoneNumber = field.phoneNumber
						}
					}
					.flagHidden(false)
					.flagSelectable(true)
					.foregroundColor(Color.white)
					.font(.systemFont(ofSize: 30, weight: .semibold, width: .standard))
					.tint(Color.app.secondaryText)
					.focused($focusField, equals: .phone)
					.frame(maxWidth: SizeConstants.screenSize.width * 0.8)
					Spacer()
				}
				flowHint(hint: "You need your phone number to sign up. Standard message and data rates apply")
			}
			.onAppear { self.setFocusField(.phone) }
		case .otpCode:
			otpCodeView()
		}
	}
	
	@ViewBuilder
	func loginFlow(_ flow: ViewModel.Context.LoginFlow) -> some View {
		switch flow {
		case .emailAndPassword:
			VStack(spacing: 30) {
				textField(hint: "Email", text: $viewModel.email, isEmail: true, onCommit: {})
				Rectangle()
					.fill(Color.app.darkGray)
					.frame(height: 1)
				secureTextField(hint: "Password", text: $viewModel.password) {
					
				}
				Button(action: {}) {
					Text("Forgot password?")
						.font(Font.app.body)
						.foregroundColor(Color.app.secondaryText)
						.underline()
				}
				.padding(.top)
			}
		case .otpCode:
			otpCodeView()
		}
	}
	
	@ViewBuilder
	func forgotPasswordFlow(_ flow: ViewModel.Context.ForgotPasswordFlow) -> some View {
		switch flow {
		case .email:
			VStack(alignment: .leading, spacing: verticalStackSpacing) {
				textField(hint: "Email", text: $viewModel.email, isEmail: true, onCommit: {})
				flowHint(hint: "Enter the email address associated with your Peas account. We’ll send you a 4-digit code to your email for verification.")
			}
		case .otpCode:
			otpCodeView()
		case .password:
			setPasswordView()
		}
	}
	
	@ViewBuilder
	func textField(hint: String, text: Binding<String>, isEmail: Bool = false, onCommit: @escaping () -> ()) -> some View {
		ZStack(alignment: .leading) {
			let foregroundColor: Color = {
				let defaultColor: Color = Color.app.secondaryText
				if isEmail {
					return text.wrappedValue.isValidEmail ? defaultColor : Color.red
				} else {
					return defaultColor
				}
			}()
			TextField("", text: text, onCommit: onCommit)
				.font(Font.app.title2Display)
				.foregroundColor(foregroundColor)
				.autocorrectionDisabled()
			textFieldHint(hint: hint, text: text)
		}
		.tint(Color.app.secondaryText)
	}
	
	@ViewBuilder
	func secureTextField(hint: String, text: Binding<String>, onCommit: @escaping () -> ()) -> some View {
		ZStack(alignment: .leading) {
			textFieldHint(hint: hint, text: text)
			SecureField("", text: text)
				.onSubmit {
					onCommit()
				}
				.font(Font.app.title2Display)
				.foregroundColor(Color.app.secondaryText)
		}
		.tint(Color.app.secondaryText)
	}
	
	@ViewBuilder
	func textFieldHint(hint: String, text: Binding<String>) -> some View {
		Text(hint)
			.font(Font.app.body)
			.foregroundColor(Color.app.tertiaryText)
			.opacity(text.wrappedValue.count > 0 ? 0.0 : 1.0)
	}
	
	@ViewBuilder
	func setPasswordView() -> some View {
		VStack(alignment: .leading, spacing: verticalStackSpacing) {
			secureTextField(hint: "Password", text: $viewModel.password) {
				self.setFocusField(.verifyPassword)
			}
			.focused($focusField, equals: .password)
			secureTextField(hint: "Verify password", text: $viewModel.verifyPassword) {
				
			}
			.focused($focusField, equals: .verifyPassword)
			VStack(alignment: .leading, spacing: 6) {
				flowInfo(info: "Must be at least \(SizeConstants.minimumPasswordCharactersCount) characters")
				flowInfo(info: "Passwords must match")
			}
		}
	}
	
	@ViewBuilder
	func otpCodeView() -> some View {
		VStack(alignment: .leading, spacing: verticalStackSpacing + 10) {
			VStack(alignment: .leading, spacing: 15) {
				Text("Enter authentication code")
					.font(Font.app.bodySemiBold)
					.foregroundColor(Color.app.secondaryText)
				Text("Enter the 6 digit code sent to your phone number")
					.font(Font.app.footnote)
					.foregroundColor(Color.app.tertiaryText)
			}
			ZStack {
				TextField("", text: $viewModel.otpCode.max(6))
					.font(.system(size: 40, weight: .semibold))
					.keyboardType(.numberPad)
					.focused($focusField, equals: .otpCode)
					.opacity(0)
				otpCodeButton()
			}
			HStack {
				Spacer()
				Button(action: {}) {
					Text("Resend code")
						.font(Font.app.title2Display)
						.underline()
						.foregroundColor(Color.app.secondaryText)
				}
				Spacer()
			}
		}
		.padding(.vertical)
		.onAppear { self.setFocusField(.otpCode) }
	}
	
	@ViewBuilder
	func otpCodeButton() -> some View {
		Button(action: { self.setFocusField(.otpCode) }) {
			let codes: [Character] = Array(viewModel.otpCode)
			HStack {
				ForEach(0..<6) { index in
					Spacer(minLength: 0)
					ZStack {
						let code: Int? = {
							if let codeChar = codes[safe: index] {
								return Int(String(codeChar))
							} else {
								return nil
							}
						}()
						otpDigitView(digit: 8)
							.opacity(0)
						otpDigitView(digit: code)
					}
					.padding()
					.background {
						VStack {
							Spacer()
							Capsule()
								.fill(Color.app.secondaryText)
								.frame(height: 3, alignment: .top)
								.padding(.horizontal, 4)
						}
					}
					Spacer(minLength: 0)
				}
			}
		}
	}
	
	@ViewBuilder
	func otpDigitView(digit: Int?) -> some View {
		if let digit = digit {
			Text(String(digit))
				.font(Font.app.largeTitle)
				.foregroundColor(Color.app.secondaryText)
		}
	}
	
	@ViewBuilder
	func flowHint(hint: String) -> some View {
		Text(hint)
			.font(Font.app.callout)
			.foregroundColor(Color.app.secondaryText)
	}
	
	@ViewBuilder
	func flowInfo(info: String) -> some View {
		HStack {
			Image(systemName: "info.circle")
			Text(info)
		}
		.font(Font.app.body)
		.foregroundColor(Color.app.secondaryBackground)
	}
	
	@ViewBuilder
	func dismissButton() -> some View {
		Button(action: dismiss) {
			Text("Cancel")
				.font(Font.app.body)
				.foregroundColor(Color.white)
		}
	}
	
	func setFocusField(_ focusField: ViewModel.FocusField?) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.focusField = focusField
		}
	}
}

struct AuthenticateView_Previews: PreviewProvider {
	static var previews: some View {
		AuthenticateView(viewModel: .init(context: .signUp(.phone)), dismiss: {})
	}
}
