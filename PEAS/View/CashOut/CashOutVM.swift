//
//  CashOutVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-24.
//

import Foundation

extension CashOutView {
	@MainActor class ViewModel: ObservableObject {
		enum Context {
			case onboarding
			case cashOut
		}
		
		let context: Context
		
		init(context: Context) {
			self.context = context
		}
	}
}
