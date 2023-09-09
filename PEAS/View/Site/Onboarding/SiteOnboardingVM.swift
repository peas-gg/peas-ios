//
//  ViewModel.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-30.
//

import Combine
import Foundation
import IdentifiedCollections
import SwiftUI

extension SiteOnboardingView {
	@MainActor class ViewModel: ObservableObject {
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var templates: IdentifiedArrayOf<Template> = []
		@Published var businessDraft: Business?
		@Published var isShowingResetWarning: Bool = false
		
		@Published var isShowingAuthenticateView: Bool = false
		@Published var isLoading: Bool = true
		
		var isUserLoggedIn: Bool {
			AppState.shared.isUserLoggedIn
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let cacheClient: CacheClient = CacheClient.shared
		
		init(draft: Business? = nil) {
			self.businessDraft = draft
		}
		
		func showResetWarning() {
			self.isShowingResetWarning = true
		}
		
		func selectTemplate(_ template: Template) {
			Task {
				let businessDraft: Business = template.business
				await cacheClient.setData(key: .businessDraft, value: businessDraft)
				withAnimation(.default) {
					self.businessDraft = businessDraft
				}
			}
		}
		
		func refreshTemplates() {
			self.apiClient
				.getTemplates()
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { completion in
						switch completion {
						case .finished: return
						case .failure:
							self.isLoading = false
						}
					},
					receiveValue: { templates in
						self.templates = IdentifiedArray(uniqueElements: templates)
						self.isLoading = false
				})
				.store(in: &cancellableBag)
		}
		
		func resetBusinessDraft() {
			Task {
				await cacheClient.delete(key: .businessDraft)
				withAnimation(.default) {
					self.businessDraft = nil
				}
			}
		}
		
		func setIsShowingAuthenticateView(_ isShowing: Bool) {
			if !isShowing {
				KeyboardClient.shared.resignKeyboard()
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					self.isShowingAuthenticateView = isShowing
				}
				return
			}
			self.isShowingAuthenticateView = isShowing
		}
		
		func proceed() {
			if isUserLoggedIn {
				
			} else {
				setIsShowingAuthenticateView(true)
			}
		}
		
		func backToWelcomeScreen() {
			AppState.shared.setAppMode(.welcome(WelcomeView.ViewModel(onboardingVM: .init())))
		}
	}
}
