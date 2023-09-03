//
//  AuthenticateView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import SwiftUI
import iPhoneNumberField

struct AuthenticateView: View {
	@StateObject var viewModel: ViewModel
	
	@FocusState var focusField: ViewModel.FocusField?
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Spacer()
				Text(viewModel.context.title)
					.font(Font.app.title2Display)
					.foregroundColor(Color.app.secondaryText)
				Spacer()
			}
			.padding(.vertical)
			.background(Color.app.darkGray)
			Spacer()
			Group {
				switch viewModel.context {
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
			Button(action: {}) {
				Text("Next")
			}
			.buttonStyle(.expanded(style: .white))
			.padding()
		}
		.background(Color.black)
	}
	
	@ViewBuilder
	func signUpFlow(_ flow: ViewModel.SignUpFlow) -> some View {
		let spacing: CGFloat = 30
		switch flow {
		case .nameAndTerms:
			VStack(spacing: spacing) {
				Spacer()
				textField(hint: "First name", text: $viewModel.firstName) {
					self.setFocusField(.lastName)
				}
				.focused($focusField, equals: .firstName)
				textField(hint: "Last name", text: $viewModel.lastName) {
					self.focusField = .firstName
				}
				.focused($focusField, equals: .lastName)
				Spacer()
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
			VStack(spacing: spacing) {
				VStack {
					textField(hint: "Email", text: $viewModel.email, onCommit: {})
					Rectangle()
						.fill(Color.app.darkGray)
						.frame(height: 1)
				}
				secureTextField(hint: "Password", text: $viewModel.password) {
					
				}
				secureTextField(hint: "Verify password", text: $viewModel.verifyPassword) {
					
				}
				HStack {
					flowHint(hint: "Must be at least 8 characters")
					Spacer()
				}
			}
		case .phone:
			VStack {
				iPhoneNumberField(text: $viewModel.phone)
					.flagHidden(false)
					.flagSelectable(true)
					.foregroundColor(Color.white)
					.font(.systemFont(ofSize: 30, weight: .semibold, width: .standard))
					.tint(Color.app.secondaryText)
					.focused($focusField, equals: .phone)
				
				Text("You need your phone number to login. Standard message and data rates apply")
					.font(Font.app.callout)
					.foregroundColor(Color.app.secondaryText)
					.padding(.top, 40)
			}
			.onAppear { self.setFocusField(.phone) }
			
		case .otpCode:
			EmptyView()
		}
	}
	
	@ViewBuilder
	func loginFlow(_ flow: ViewModel.LoginFlow) -> some View {
		switch flow {
		case .emailAndPassword:
			EmptyView()
		case .otpCode:
			EmptyView()
		}
	}
	
	@ViewBuilder
	func forgotPasswordFlow(_ flow: ViewModel.ForgotPasswordFlow) -> some View {
		switch flow {
		case .email:
			EmptyView()
		case .otpCode:
			EmptyView()
		case .password:
			EmptyView()
		}
	}
	
	@ViewBuilder
	func textField(hint: String, text: Binding<String>, onCommit: @escaping () -> ()) -> some View {
		ZStack(alignment: .leading) {
			TextField("", text: text, onCommit: onCommit)
				.font(Font.app.title2Display)
				.foregroundColor(Color.app.secondaryText)
				.autocorrectionDisabled()
			textFieldHint(hint: hint, text: text)
		}
		.tint(Color.app.secondaryText)
	}
	
	@ViewBuilder
	func secureTextField(hint: String, text: Binding<String>, onCommit: @escaping () -> ()) -> some View {
		ZStack(alignment: .leading) {
			SecureField("", text: text)
				.onSubmit {
					onCommit()
				}
				.font(Font.app.title2Display)
				.foregroundColor(Color.app.secondaryText)
			textFieldHint(hint: hint, text: text)
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
	func flowHint(hint: String) -> some View {
		HStack {
			Image(systemName: "info.circle")
			Text(hint)
		}
		.font(Font.app.body)
		.foregroundColor(Color.app.secondaryBackground)
	}
	
	func setFocusField(_ focusField: ViewModel.FocusField) {
		self.focusField = focusField
	}
}

struct AuthenticateView_Previews: PreviewProvider {
	static var previews: some View {
		AuthenticateView(viewModel: .init(context: .signUp(.phone)))
	}
}
