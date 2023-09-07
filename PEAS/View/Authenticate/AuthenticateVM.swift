//
//  AuthenticateVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import Foundation

extension AuthenticateView {
	@MainActor class ViewModel: ObservableObject {
		enum Context: Hashable {
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
			
			var pageTitle: String {
				switch self {
				case .signUp(let signUpFlow):
					switch signUpFlow {
					case .nameAndTerms: return ""
					case .emailAndPassword: return "Email & Password"
					case .phone: return "Phone"
					case .otpCode: return "Code"
					}
				case .login(let loginFlow):
					switch loginFlow {
					case .emailAndPassword: return ""
					case .otpCode: return "Code"
					}
				case .forgotPassword(let forgotPasswordFlow):
					switch forgotPasswordFlow {
					case .email: return ""
					case .otpCode: return "Code"
					case .password: return "New password"
					}
				}
			}
		}
		
		enum FocusField: Hashable {
			case firstName
			case lastName
			case email
			case password
			case verifyPassword
			case phone
			case otpCode
		}
		
		@Published var context: Context
		
		@Published var firstName: String = ""
		@Published var lastName: String = ""
		@Published var email: String = ""
		@Published var password: String = ""
		@Published var verifyPassword: String = ""
		@Published var phone: String = ""
		@Published var otpCode: String = ""
		
		@Published var navStack: [Context] = []
		
		init(context: Context) {
			self.context = context
		}
		
		func canAdvance(context: Context) -> Bool {
			switch context {
			case .signUp(let signUpFlow):
				switch signUpFlow {
				case .nameAndTerms:
					return firstName.isValidName && lastName.isValidName
				case .emailAndPassword:
					return password.isValidPassword && password == verifyPassword
				case .phone, .otpCode:
					return true
				}
			case .login(let loginFlow):
				switch loginFlow {
				case .emailAndPassword:
					return email.isValidEmail && password.isValidPassword
				case .otpCode:
					return true
				}
			case .forgotPassword(let forgotPasswordFlow):
				switch forgotPasswordFlow {
				case .email, .otpCode:
					return true
				case .password:
					return password.isValidPassword && password == verifyPassword
				}
			}
		}
		
		func advanceButtonTitle(context: Context) -> String {
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
					return defaultText
				case .password:
					return "Reset"
				}
			}
		}
		
		func advance(current: Context) {
			switch current {
			case .signUp(let signUpFlow):
				switch signUpFlow {
				case .nameAndTerms:
					self.navStack.append(.signUp(.emailAndPassword))
				case .emailAndPassword:
					self.navStack.append(.signUp(.phone))
				case .phone:
					self.navStack.append(.signUp(.otpCode))
				case .otpCode:
					return
				}
			case .login(let loginFlow):
				switch loginFlow {
				case .emailAndPassword:
					self.navStack.append(.login(.otpCode))
				case .otpCode:
					return
				}
			case .forgotPassword(let forgotPasswordFlow):
				switch forgotPasswordFlow {
				case .email:
					self.navStack.append(.forgotPassword(.otpCode))
				case .otpCode:
					self.navStack.append(.forgotPassword(.password))
				case .password:
					return
				}
			}
		}
		
		func switchToLoginContext() {
			self.context = .login(.emailAndPassword)
		}
	}
}
