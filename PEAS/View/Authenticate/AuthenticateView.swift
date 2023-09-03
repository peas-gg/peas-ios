//
//  AuthenticateView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import SwiftUI

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
			switch viewModel.context {
			case .signUp(let flow):
				signUpFlow(flow)
			case .login(let flow):
				loginFlow(flow)
			case .forgotPassword(let flow):
				forgotPasswordFlow(flow)
			}
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
		switch flow {
		case .nameAndTerms:
			VStack(spacing: 30) {
				textField(hint: "First name", text: $viewModel.firstName) {
					self.setFocusField(.lastName)
				}
				.focused($focusField, equals: .firstName)
				textField(hint: "Last name", text: $viewModel.lastName) {
					self.focusField = .firstName
				}
				.focused($focusField, equals: .lastName)
			}
			.multilineTextAlignment(.leading)
			.padding(.horizontal, 30)
			.onAppear { self.setFocusField(.firstName) }
		case .emailAndPassword:
			EmptyView()
		case .phone:
			EmptyView()
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
			Text(hint)
				.font(Font.app.body)
				.foregroundColor(Color.app.tertiaryText)
				.opacity(text.wrappedValue.count > 0 ? 0.0 : 1.0)
		}
		.tint(Color.app.secondaryText)
	}
	
	func setFocusField(_ focusField: ViewModel.FocusField) {
		self.focusField = focusField
	}
}

struct AuthenticateView_Previews: PreviewProvider {
	static var previews: some View {
		AuthenticateView(viewModel: .init(context: .signUp(.nameAndTerms)))
	}
}
