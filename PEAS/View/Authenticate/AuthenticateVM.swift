//
//  AuthenticateVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import Foundation

extension AuthenticateView {
	@MainActor class ViewModel: ObservableObject {
		enum Context {
			case signUp(SignUpFlow)
			case login(LoginFlow)
			case forgotPassword(ForgotPasswordFlow)
			
			var title: String {
				switch self {
				case .signUp: return "Sign up"
				case .login: return "Login"
				case .forgotPassword: return "Forgot password"
				}
			}
		}
		
		enum SignUpFlow {
			case nameAndTerms
			case emailAndPassword
			case phone
			case otpCode
		}
		
		enum LoginFlow {
			case emailAndPassword
			case otpCode
		}
		
		enum ForgotPasswordFlow {
			case email
			case otpCode
			case password
		}
		
		enum FocusField: Hashable {
			case firstName
			case lastName
			case phone
			case otpCode
		}
		
		let context: Context
		
		@Published var firstName: String = ""
		@Published var lastName: String = ""
		@Published var email: String = ""
		@Published var password: String = ""
		@Published var verifyPassword: String = ""
		@Published var phone: String = ""
		@Published var otpCode: String = "444444"
		
		@Published var signUpFlow: [SignUpFlow] = []
		@Published var loginFlow: [LoginFlow] = []
		@Published var forgotPasswordFlow: [ForgotPasswordFlow] = []
		
		var buttonTitle: String {
			let defaultText: String = "Next"
			switch context {
			case .signUp(let signUpFlow):
				switch signUpFlow {
				case .nameAndTerms, .emailAndPassword, .phone:
					return defaultText
				case .otpCode:
					return "Sign up"
				}
			case .login(let loginFlow):
				switch loginFlow {
				case .emailAndPassword:
					return defaultText
				case .otpCode:
					return "Login"
				}
			case .forgotPassword(let forgotPasswordFlow):
				switch forgotPasswordFlow {
				case .email:
					return defaultText
				case .otpCode:
					return "Set password"
				case .password:
					return "Reset"
				}
			}
		}
		
		init(context: Context) {
			self.context = context
		}
	}
}
