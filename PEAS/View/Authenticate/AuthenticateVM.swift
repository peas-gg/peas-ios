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
			case signUp
			case login
			case forgotPassword
			
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
		
		enum ForgotPassword {
			case email
			case otpCode
			case password
		}
	}
}
