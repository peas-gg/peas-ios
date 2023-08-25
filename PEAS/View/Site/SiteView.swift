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
	
	var body: some View {
		VStack {
			VStack {
				HStack {
					Image("siteLogo")
						.resizable()
						.scaledToFit()
						.frame(dimension: 40)
					Spacer()
				}
				Spacer()
			}
			.padding(.horizontal)
		}
		.background(backgroundColour)
		.animation(.easeInOut, value: backgroundColour)
	}
}

struct SiteView_Previews: PreviewProvider {
	static var previews: some View {
		SiteView(viewModel: .init(isTemplate: true, business: Business.mock1))
	}
}
