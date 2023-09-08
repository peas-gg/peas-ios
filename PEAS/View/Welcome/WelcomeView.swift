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
		
		ZStack{
			
			VStack {
				Rectangle()
					.fill(
						AngularGradient(
							colors: page.pageColor,
							center: .center,
							angle: .degrees(270)
						)
					)
					.frame(maxHeight: 300)
					.blur(radius: 50)
					.padding(.top)
				Spacer()
				
			}
			.background(Color.black)
			
			GeometryReader { geometry in
				ZStack {
					//Color.black.edgesIgnoringSafeArea(.all)
			
					// Create horizontal lines using LazyVStack
					LazyVStack(spacing: 45) {
			
						ForEach(0..<rows, id: \.self) { _ in
							Rectangle()
								.fill(Color.white)
								.frame(height: 0.5) // Line height
							Spacer()
						}
					}
					
			
					// Create vertical lines using LazyHStack
					LazyHStack(spacing: 45) {
						ForEach(0..<columns, id: \.self) { _ in
							Rectangle()
								.fill(Color.white)
								.frame(width: 0.5) // Line width
							Spacer()
						}
					}
				}
				.ignoresSafeArea()
			}
			
		}
		
	}
}


struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView(viewModel: .init(onboardingVM: .init()))
	}
}


