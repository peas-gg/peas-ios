//
//  AppState.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-24.
//

import Combine
import Foundation
import SwiftUI

fileprivate let appStateKeyNotification: String = "appState"

@MainActor class AppState: ObservableObject {
	static let shared: AppState = AppState()
	
	private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
	
	enum AppMode {
		case welcome(WelcomeView.ViewModel)
		case onboarding(SiteOnboardingView.ViewModel)
		case home(HomeView.ViewModel)
	}
	
	enum AppAction {
		case changeAppMode(AppMode)
	}
	
	@Published var mode: AppMode?
	@Published var isUserLoggedIn: Bool = false
	
	@Published var isShowingRequestPayment: Bool = false
	
	//Clients
	let apiClient = APIClient.shared
	let cacheClient = CacheClient.shared
	let keychainClient = KeychainClient.shared
	
	init() {
		refreshAppMode()
	}
	
	private func refreshAppMode() {
		Task(priority: .high) {
			let businessDraft = await cacheClient.getData(key: .businessDraft)
			let onboardingVM = SiteOnboardingView.ViewModel(draft: businessDraft)
			
			let user = keychainClient.get(key: .user)
			let business = keychainClient.get(key: .business)
			
			//APPMode Logic
			/**
			 (1). If a user is logged in and they have a business site, take them to the HomeView
			 (2). If a user is logged in but does not have a business site, take them to the SiteOnboardingView to create one
			 (3). If a user is not logged in, take them to the WelcomeView
			 */
			if let user = user {
				self.isUserLoggedIn = true
				self.mode = nil
				if let business = business {
					self.mode = .home(HomeView.ViewModel(user: user, business: business))
				} else {
					//Attempt to fetch the user's business
					apiClient.getBusinessAccount()
						.receive(on: DispatchQueue.main)
						.sink(
							receiveCompletion: { completion in
								switch completion {
								case .finished: return
								case .failure:
									self.mode = .onboarding(onboardingVM)
									return
								}
							},
							receiveValue: { business in
								Task {
									await self.cacheClient.delete(key: .businessDraft)
									self.keychainClient.set(key: .business, value: business)
									self.mode = .home(HomeView.ViewModel(user: user, business: business))
								}
							}
						)
						.store(in: &cancellableBag)
				}
			} else {
				if businessDraft != nil {
					self.mode = .onboarding(onboardingVM)
				} else {
					self.mode = .welcome(WelcomeView.ViewModel(onboardingVM: onboardingVM))
				}
			}
		}
	}
	
	func setAppMode(_ mode: AppMode) {
		withAnimation(.default) {
			self.mode = mode
		}
	}
	
	func setIsShowingPaymentView(_ isShowing: Bool) {
		self.isShowingRequestPayment = isShowing
	}
	
	func logUserIn(_ authenticateResponse: AuthenticateResponse) {
		let user: User = User(
			firstName: authenticateResponse.firstName,
			lastName: authenticateResponse.lastName,
			email: authenticateResponse.email,
			interacEmail: authenticateResponse.interacEmail,
			phone: authenticateResponse.phone,
			role: authenticateResponse.role,
			accessToken: authenticateResponse.jwtToken,
			refreshToken: authenticateResponse.refreshToken
		)
		self.keychainClient.set(key: .user, value: user)
		self.refreshAppMode()
	}
}
