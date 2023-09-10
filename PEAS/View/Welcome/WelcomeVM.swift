//
//  WelcomeVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import Foundation
import SwiftUI

extension WelcomeView {
	@MainActor class ViewModel: ObservableObject {
		enum Page: String, Identifiable, CaseIterable {
			case createSite
			case dropLink
			case acceptPayment
			
			var id: String {
				return self.rawValue
			}
			
			var pageColors: [Color]{
				switch self {
				case .createSite: return [
					Color(UIColor(hex: "A5F0FB")),
					Color(UIColor(hex: "61D3BE")),
					Color(UIColor(hex: "5EA6CE")),
					Color(UIColor(hex: "005656"))
				]
				case .dropLink: return
					[
						Color(UIColor(hex: "FBA5E3")),
						Color(UIColor(hex: "D3618A")),
						Color(UIColor(hex: "AA5ECE")),
						Color(UIColor(hex: "560029"))
					]
				case .acceptPayment: return
					[
						Color(UIColor(hex: "A5FBA5")),
						Color(UIColor(hex: "BCD361")),
						Color(UIColor(hex: "CECA5E")),
						Color(UIColor(hex: "005620"))
					]
				}
			}
			
			var pageImage: String {
				switch self {
				case .createSite: return "CreatePeasSite"
				case .dropLink: return "DropLinkInBio"
				case .acceptPayment: return "AcceptBookings"
				}
			}
			
			var pageTitle: String {
				switch self {
				case .createSite: return "Create your PEAS \nsite"
				case .dropLink: return "Drop the link in your \nbio"
				case .acceptPayment: return "Accept bookings &\npayments"
				}
			}
		}
		
		let onboardingVM: SiteOnboardingView.ViewModel
		
		@Published var currentPage: Page = .createSite
		@Published var isShowingAuthenticateView: Bool = false
		
		init(onboardingVM: SiteOnboardingView.ViewModel) {
			self.onboardingVM = onboardingVM
		}
		
		func startOnboarding() {
			AppState.shared.setAppMode(.onboarding(onboardingVM))
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
	}
}
