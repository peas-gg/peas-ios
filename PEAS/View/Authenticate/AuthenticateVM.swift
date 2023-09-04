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
		
		init(context: Context) {
			self.context = context
		}
	}
}
