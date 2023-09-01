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
		@Published var selectedTemplate: Template?
		@Published var isShowingResetWarning: Bool = false
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		
		init() {
			self.apiClient
				.getTemplates()
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { _ in },
					receiveValue: { templates in
					self.templates = IdentifiedArray(uniqueElements: templates)
				})
				.store(in: &cancellableBag)
		}
		
		func showResetWarning() {
			self.isShowingResetWarning = true
		}
		
		func selectTemplate(_ template: Template) {
			withAnimation(.default) {
				self.selectedTemplate = template
			}
		}
		
		func resetTemplate() {
			withAnimation(.default) {
				self.selectedTemplate = nil
			}
		}
		
		func backToWelcomeScreen() {
			AppState.updateAppState(with: .changeAppMode(.welcome))
		}
	}
}
