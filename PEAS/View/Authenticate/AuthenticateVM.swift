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
					case .email: return "Forgot password"
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
		@Published var didAcceptPrivacyAndTermsConditions: Bool = false
		@Published var isShowingPrivacySheet: Bool = false
		@Published var isShowingTermsSheet: Bool = false
		@Published var isLoadingWebView: Bool = false
		
		@Published var didCompleteAuthentication: Bool = false
		
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
		
		func privacyButtonTapped() {
			self.isLoadingWebView = true
			self.isShowingPrivacySheet = true
			self.didReadPrivacy = true
		}
		
		func termsButtonTapped() {
			self.isLoadingWebView = true
			self.isShowingTermsSheet = true
			self.didReadTerms = true
		}
		
		func acceptPrivacyAndTerms() {
			self.isAnimatingTermsButton = !didReadTerms
			self.isAnimatingPrivacyButton = !didReadPrivacy
			if didReadTerms && didReadPrivacy {
				self.didAcceptPrivacyAndTermsConditions.toggle()
			}
		}
		
		func resendOtpCode(context: Context) {
			switch context {
			case .signUp(.otpCode):
				requestOtpCodeSignUp(shouldAdvanceNav: false)
			case .login(.otpCode):
				requestOtpCodeLogin(shouldAdvanceNav: false)
			case .forgotPassword(.otpCode):
				requestOtpCodeForgotPassword(shouldAdvanceNav: false)
			default: return
			}
		}
		
		func canAdvance(context: Context) -> Bool {
			switch context {
			case .signUp(let signUpFlow):
				switch signUpFlow {
				case .nameAndTerms:
					return firstName.isValidName && lastName.isValidName && didAcceptPrivacyAndTermsConditions
				case .emailAndPassword:
					return password.isValidPassword && password == verifyPassword
				case .phone:
					return phoneNumber != nil
				case .otpCode:
					return otpCode.isValidOtpCode
				}
			case .login(let loginFlow):
				switch loginFlow {
				case .emailAndPassword:
					return email.isValidEmail && password.isValidPassword
				case .otpCode:
					return otpCode.isValidOtpCode
				}
			case .forgotPassword(let forgotPasswordFlow):
				switch forgotPasswordFlow {
				case .email:
					return email.isValidEmail
				case .otpCode:
					return otpCode.isValidOtpCode
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
					requestOtpCodeSignUp(shouldAdvanceNav: true)
				case .otpCode:
					if let phoneNumber = self.phoneNumberToString {
						self.isLoading = true
						let registerModel: RegisterRequest = RegisterRequest(
							firstName: self.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
							lastName: self.lastName.trimmingCharacters(in: .whitespacesAndNewlines),
							email: self.email.trimmingCharacters(in: .whitespacesAndNewlines),
							phone: phoneNumber,
							passwordText: self.password,
							code: self.otpCode,
							acceptTerms: self.didAcceptPrivacyAndTermsConditions
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
									self.didCompleteAuthentication = true
									AppState.shared.logUserIn(authenticateResponse)
								}
							)
							.store(in: &cancellableBag)
					}
				}
			case .login(let loginFlow):
				switch loginFlow {
				case .emailAndPassword:
					requestOtpCodeLogin(shouldAdvanceNav: true)
				case .otpCode:
					self.isLoading = true
					let authenticateRequest: AuthenticateRequest = AuthenticateRequest(
						email: self.email,
						password: self.password,
						code: self.otpCode
					)
					self.apiClient
						.authenticateWithCode(authenticateRequest)
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
								self.didCompleteAuthentication = true
								AppState.shared.logUserIn(authenticateResponse)
							}
						)
						.store(in: &cancellableBag)
				}
			case .forgotPassword(let forgotPasswordFlow):
				switch forgotPasswordFlow {
				case .email:
					requestOtpCodeForgotPassword(shouldAdvanceNav: true)
				case .otpCode:
					self.navStack.append(.forgotPassword(.password))
				case .password:
					self.isLoading = true
					let resetPasswordRequest: ResetPasswordRequest = ResetPasswordRequest(
						email: self.email,
						password: self.password,
						code: self.otpCode
					)
					self.apiClient
						.resetPassword(resetPasswordRequest)
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
								self.navStack = []
								self.resetEmailAndPasswordFields()
								self.context = .login(.emailAndPassword)
							}
						)
						.store(in: &cancellableBag)
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
			resetEmailAndPasswordFields()
			self.context = .login(.emailAndPassword)
		}
		
		func forgotPasswordTapped() {
			resetEmailAndPasswordFields()
			self.navStack.append(.forgotPassword(.email))
		}
		
		private func resetEmailAndPasswordFields() {
			self.email = ""
			self.password = ""
			self.verifyPassword = ""
			self.otpCode = ""
		}
		
		private func requestOtpCodeSignUp(shouldAdvanceNav: Bool) {
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
							if shouldAdvanceNav {
								self.navStack.append(.signUp(.otpCode))
							}
						}
					)
					.store(in: &cancellableBag)
			}
		}
		
		private func requestOtpCodeLogin(shouldAdvanceNav: Bool) {
			self.isLoading = true
			let authenticateRequest: AuthenticateRequest = AuthenticateRequest(
				email: self.email,
				password: self.password,
				code: nil
			)
			self.apiClient
				.authenticate(authenticateRequest)
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
						if shouldAdvanceNav {
							self.navStack.append(.login(.otpCode))
						}
					}
				)
				.store(in: &cancellableBag)
		}
		
		private func requestOtpCodeForgotPassword(shouldAdvanceNav: Bool) {
			self.isLoading = true
			self.apiClient
				.requestPasswordReset(email: self.email)
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
						if shouldAdvanceNav {
							self.navStack.append(.forgotPassword(.otpCode))
						}
					}
				)
				.store(in: &cancellableBag)
		}
	}
}
