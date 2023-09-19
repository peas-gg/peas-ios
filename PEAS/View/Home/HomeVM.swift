//
//  HomeVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-24.
//

import Foundation

extension HomeView {
	@MainActor class ViewModel: ObservableObject {
		@Published var siteVM: SiteView.ViewModel
		
		init(user: User, business: Business) {
			self.siteVM = SiteView.ViewModel(isTemplate: false, business: business)
		}
	}
}
