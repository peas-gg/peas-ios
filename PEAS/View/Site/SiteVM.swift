//
//  SiteVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import Combine
import Foundation

extension SiteView {
	@MainActor class ViewModel: ObservableObject {
		let isTemplate: Bool
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var colours: Dictionary<String, String> = Dictionary<String, String>()
		
		@Published var business: Business
		
		@Published var isInEditMode: Bool = false
		
		@Published var peasSign: String = ""
		@Published var businessName: String = ""
		@Published var description: String = ""
		
		@Published var editModeContext: EditSiteView.Context?
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		
		init(isTemplate: Bool, business: Business) {
			self.isTemplate = isTemplate
			self.business = business
			self.apiClient
				.getColours()
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { _ in },
					receiveValue: { colours in
					self.colours = colours
				})
				.store(in: &cancellableBag)
		}
		
		func setBackgroundColor(colorName: String) {
			self.business.color = colorName
		}
		
		func setEditModeContext(_ context: EditSiteView.Context?) {
			self.editModeContext = context
		}
		
		func toggleEditMode() {
			self.isInEditMode.toggle()
		}
	}
}
