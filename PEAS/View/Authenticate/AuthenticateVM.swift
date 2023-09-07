//
//  AuthenticateVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import Combine
import Foundation
import PhoneNumberKit

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
		
		let phoneNumberKit: PhoneNumberKit = PhoneNumberKit()
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var context: Context
		
		@Published var firstName: String = ""
		@Published var lastName: String = ""
		@Published var email: String = ""
		@Published var password: String = ""
		@Published var verifyPassword: String = ""
		@Published var phone: String = ""
		@Published var phoneNumber: PhoneNumber?
		@Published var otpCode: String = ""
		
		@Published var navStack: [Context] = []
		
		@Published var isAnimatingPrivacyButton: Bool = false
		@Published var isAnimatingTermsButton: Bool = false
		@Published var didReadPrivacy: Bool = false
		@Published var didReadTerms: Bool = false
		
		@Published var isLoading: Bool = false
		@Published var bannerData: BannerData?
		
		var phoneNumberToString: String? {
			if let phoneNumber = phoneNumber {
				return phoneNumberKit.format(phoneNumber, toType: .e164)
			} else {
				return nil
			}
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		
		init(context: Context) {
			self.context = context
		}
		
		func acceptTerms() {
			self.isAnimatingTermsButton = !didReadTerms
			self.isAnimatingPrivacyButton = !didReadPrivacy
		}
		
		func canAdvance(context: Context) -> Bool {
			switch context {
			case .signUp(let signUpFlow):
				switch signUpFlow {
				case .nameAndTerms:
					return firstName.isValidName && lastName.isValidName
				case .emailAndPassword:
					return password.isValidPassword && password == verifyPassword
				case .phone:
					return phoneNumber != nil
				case .otpCode:
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
					if let phoneNumber = self.phoneNumberToString {
						self.isLoading = true
						self.apiClient
							.requestOtpCode(phoneNumber: phoneNumber)
							.receive(on: DispatchQueue.main)
							.sink(
								receiveCompletion: { completion in
									switch completion {
									case .finished: return
									case .failure(let error):
										self.isLoading = false
										self.bannerData = BannerData(error: error)
									}
								},
								receiveValue: { _ in
									self.isLoading = false
									self.navStack.append(.signUp(.otpCode))
								}
							)
							.store(in: &cancellableBag)
					}
				case .otpCode:
					self.isLoading = true
					if let phoneNumber = self.phoneNumberToString {
						let registerModel: RegisterRequest = RegisterRequest(
							firstName: self.firstName,
							lastName: self.lastName,
							email: self.email,
							phone: phoneNumber,
							passwordText: self.password,
							code: self.otpCode,
							acceptTerms: false
						)
						self.apiClient
							.register(registerModel)
							.receive(on: DispatchQueue.main)
							.sink(
								receiveCompletion: { completion in
									switch completion {
									case .finished: return
									case .failure(let error):
										self.isLoading = false
										self.bannerData = BannerData(error: error)
									}
								},
								receiveValue: { authenticateResponse in
									self.isLoading = false
								}
							)
							.store(in: &cancellableBag)
					}
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
		
		func updatePhoneNumber(_ number: PhoneNumber?) {
			self.phoneNumber = number
			if let phoneNumber {
				print(phoneNumberKit.format(phoneNumber, toType: .e164))
			}
		}
		
		func switchToLoginContext() {
			self.context = .login(.emailAndPassword)
		}
	}
}
