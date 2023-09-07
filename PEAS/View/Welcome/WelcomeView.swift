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
		
		var pageColor: [Color]{
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
		
		let rows = 5 // Number of horizontal lines
		let columns = 5 // Number of vertical lines
		
		ZStack {
			VStack {
				Rectangle()
					.fill(
						AngularGradient(
							colors: page.pageColor,
							center: .center,
							angle: .degrees(270)
						)
					)
					.frame(maxHeight: 340)
					.blur(radius: 50)
					.padding(.top)
				Spacer()
			}
			.background(Color.black)
			VStack {
				ZStack {
					LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 5), spacing: 0) {
						ForEach(0..<30) {
							Rectangle()
								.stroke(Color.white.opacity(0.1))
								.frame(minHeight: 80)
								.id($0)
						}
					}
					.overlay(alignment: .top) {
						Rectangle()
							.fill(
								LinearGradient(
									colors: [
										Color.black,
										Color.black.opacity(0.8),
										Color.black.opacity(0.4),
										Color.clear
									],
									startPoint: .top,
									endPoint: .bottom
								)
							)
							.frame(height: 180)
						.edgesIgnoringSafeArea(.top)
					}
					.overlay(alignment: .bottom) {
						let height: CGFloat = 80
						Rectangle()
							.fill(
								LinearGradient(
									colors: [
										Color.clear,
										Color.black.opacity(0.2),
										Color.black.opacity(0.4),
										Color.black.opacity(0.8),
										Color.black
									],
									startPoint: .top,
									endPoint: .bottom
								)
							)
							.frame(height: height)
							.offset(y: 10)
						.edgesIgnoringSafeArea(.top)
					}
				}
				Spacer()
			}
			
		}
		
	}
}

struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView(viewModel: .init(onboardingVM: .init()))
	}
}
