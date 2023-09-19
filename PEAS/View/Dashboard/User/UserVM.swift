//
//  UserVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-11.
//

import Foundation

extension UserView {
	@MainActor class ViewModel: ObservableObject {
		let user: User
		
		init(user: User) {
			self.user = user
		}
	}
}
