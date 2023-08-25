//
//  SiteVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import Foundation

extension SiteView {
	@MainActor class ViewModel: ObservableObject {
		let isTemplate: Bool
		
		@Published var business: Business
		
		init(isTemplate: Bool, business: Business) {
			self.isTemplate = isTemplate
			self.business = business
		}
	}
}
