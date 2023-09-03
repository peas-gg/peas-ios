//
//  AuthenticateView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import SwiftUI

struct AuthenticateView: View {
	@StateObject var viewModel: ViewModel
	
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
			VStack {
				textField(hint: "First name", text: $viewModel.firstName)
				textField(hint: "Last name", text: $viewModel.lastName)
			}
			.multilineTextAlignment(.leading)
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
	func textField(hint: String, text: Binding<String>) -> some View {
		ZStack(alignment: .leading) {
			TextField("", text: text)
				.font(Font.app.title2Display)
				.foregroundColor(Color.app.secondaryText)
			Text(hint)
				.font(Font.app.body)
				.foregroundColor(Color.app.tertiaryText)
				.opacity(text.wrappedValue.count > 0 ? 0.0 : 1.0)
		}
	}
}

struct AuthenticateView_Previews: PreviewProvider {
	static var previews: some View {
		AuthenticateView(viewModel: .init(context: .signUp(.nameAndTerms)))
	}
}
