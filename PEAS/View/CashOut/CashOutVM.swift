//
//  CashOutVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-24.
//

import Foundation

extension CashOutView {
	@MainActor class ViewModel: ObservableObject {
		enum Context {
			case onboarding
			case cashOut
		}
		
		enum EmailSelection {
			case account
			case different
		}
		
		let context: Context
		
		@Published var user: User
		
		@Published var currentEmailSelection: EmailSelection = .account
		@Published var differentEmail: String = ""
		@Published var isShowingConfirmation: Bool = false
		
		var selectedEmail: String {
			switch currentEmailSelection {
			case .account: return user.email
			case .different: return differentEmail
			}
		}
		
		init(user: User, context: Context) {
			self.user = user
			self.context = context
		}
		
		func selectEmail(selection: EmailSelection) {
			switch selection {
			case .account:
				self.currentEmailSelection = selection
			case .different:
				if differentEmail.isValidEmail {
					self.currentEmailSelection = selection
				}
			}
		}
		
		func setIsShowingConfirmation(_ isShowing: Bool) {
			self.isShowingConfirmation = isShowing
		}
		
		func advance() {
			if self.isShowingConfirmation {
				//Send request to api
			} else {
				self.isShowingConfirmation = true
			}
		}
	}
}