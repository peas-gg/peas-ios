//
//  ViewModel.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-30.
//

import Combine
import Foundation
import IdentifiedCollections

extension SiteOnboardingView {
	@MainActor class ViewModel: ObservableObject {
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var templates: IdentifiedArrayOf<Template> = []
		
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
	}
}
