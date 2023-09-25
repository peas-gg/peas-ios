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
		
		init(user: User) {
			if user.interacEmail == nil {
				self.context = .onboarding
			} else {
				self.context = .cashOut
			}
			self.user = user
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
	}
}
