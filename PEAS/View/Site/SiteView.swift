//
//  SiteView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct SiteView: View {
	@StateObject var viewModel: ViewModel
	
	var backgroundColour: Color {
		let colorHex: String? = viewModel.colours[viewModel.business.color]
		if let colorHex = colorHex {
			return Color(uiColor: UIColor(hex: colorHex))
		}
		return Color.white
	}
	
	var business: Business {
		viewModel.business
	}
	
	var body: some View {
		VStack {
			VStack {
				HStack {
					Image("siteLogo")
						.resizable()
						.scaledToFit()
						.frame(dimension: 40)
					Text("/\(business.sign)")
						.font(Font.app.title2)
					Spacer()
				}
				HStack(alignment: .top) {
					CachedAvatar(url: business.profilePhoto, height: 60)
					VStack {
						Text("\(business.name)")
							.font(Font.app.title2Display)
						ScrollView(.horizontal, showsIndicators: false) {
							HStack {
								ForEach(Array(viewModel.colours.keys), id: \.self) { colorName in
									colorButton(colorName: colorName)
								}
							}
						}
					}
					.padding(.top, 4)
					Spacer()
				}
				.padding(.vertical)
				
				Spacer()
			}
			.padding(.horizontal)
		}
		.background(backgroundColour.ignoresSafeArea().animation(.easeOut, value: backgroundColour))
	}
	
	@ViewBuilder
	func colorButton(colorName: String) -> some View {
		let color: Color = {
			let colorHex: String? = viewModel.colours[colorName]
			if let colorHex = colorHex {
				return Color(uiColor: UIColor(hex: colorHex))
			}
			return Color.gray
		}()
		let isCurrentColor: Bool = color == backgroundColour
		Button(action: { viewModel.setBackgroundColor(colorName: colorName) }) {
			ZStack{
				Circle()
					.fill(Color.white)
				Circle()
					.fill(color)
					.padding(isCurrentColor ? 2 : 0)
			}
			.frame(dimension: 36)
		}
		.buttonStyle(.insideScaling)
	}
}

struct SiteView_Previews: PreviewProvider {
	static var previews: some View {
		SiteView(viewModel: .init(isTemplate: true, business: Business.mock1))
	}
}
