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
		
		@Published var isShowingLogOutAlert: Bool = false
		
		init(user: User) {
			self.user = user
		}
		
		func requestLogOut() {
			self.isShowingLogOutAlert = true
		}
		
		func logOut() {
			AppState.shared.logUserOut(isUserRequested: true)
		}
	}
}
