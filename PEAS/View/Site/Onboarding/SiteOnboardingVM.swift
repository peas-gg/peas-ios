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
		@Published var businessDraft: BusinessDraft?
		@Published var isShowingResetWarning: Bool = false
		
		@Published var isLoading: Bool = true
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		
		init() {
			refreshTemplates()
		}
		
		func showResetWarning() {
			self.isShowingResetWarning = true
		}
		
		func selectTemplate(_ template: Template) {
			withAnimation(.default) {
				self.businessDraft = BusinessDraft(business: template.business)
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
						if templates != self.templates.elements {
							self.templates = IdentifiedArray(uniqueElements: templates)
						}
						self.isLoading = false
				})
				.store(in: &cancellableBag)
		}
		
		func resetBusinessDraft() {
			withAnimation(.default) {
				self.businessDraft = nil
			}
		}
		
		func backToWelcomeScreen() {
			AppState.updateAppState(with: .changeAppMode(.welcome))
		}
	}
}
