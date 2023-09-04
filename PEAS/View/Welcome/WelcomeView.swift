//
//  WelcomeView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import SwiftUI

struct WelcomeView: View {
	enum Page: String, Identifiable, CaseIterable {
		case createSite
		case dropLink
		case acceptPayment
		
		var id: String {
			return self.rawValue
		}
	}
	
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		TabView {
			ForEach(Page.allCases) { page in
				background(page: page)
					.tag(page)
			}
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
		.edgesIgnoringSafeArea(.all)
		.onAppear { UIScrollView.appearance().bounces = false }
	}
	
	@ViewBuilder
	func background(page: Page) -> some View {
		let colors: [Color] = {
			switch page {
			case .createSite:
				return [
					Color(UIColor(hex: "A5F0FB")),
					Color(UIColor(hex: "61D3BE")),
					Color(UIColor(hex: "5EA6CE")),
					Color(UIColor(hex: "005656"))
				]
			case .dropLink:
				return [
					Color(UIColor(hex: "FBA5E3")),
					Color(UIColor(hex: "D3618A")),
					Color(UIColor(hex: "AA5ECE")),
					Color(UIColor(hex: "560029"))
				]
			case .acceptPayment:
				return [
					Color(UIColor(hex: "A5FBA5")),
					Color(UIColor(hex: "BCD361")),
					Color(UIColor(hex: "CECA5E")),
					Color(UIColor(hex: "005620"))
				]
			}
		}()
		VStack {
			Rectangle()
				.fill(
					AngularGradient(
						colors: colors,
						center: .center,
						angle: .degrees(270)
					)
				)
				.frame(maxHeight: 400)
				.blur(radius: 50)
				.padding(.top)
			Spacer()
		}
		.background(Color.black)
	}
}

struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView(viewModel: .init(onboardingVM: .init()))
	}
}
