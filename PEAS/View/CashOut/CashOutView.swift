//
//  CashOutView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-24.
//

import SwiftUI

struct CashOutView: View {
	@StateObject var viewModel: ViewModel
	
	let pageTitle: String = "CashOut"
	
	var body: some View {
		switch viewModel.context {
		case .onboarding:
			VStack(spacing: 0) {
				SymmetricHStack(
					content: {
						Text(pageTitle)
							.font(Font.app.title2Display)
					},
					leading: {
						EmptyView()
					},
					trailing: {
						Button(action: {}) {
							Text("Done")
								.font(.system(size: FontSizes.title3))
								.padding()
						}
					}
				)
				Divider()
					.padding(.top)
				VStack {
					HStack(spacing: 10) {
						Spacer()
						Image("SiteLogo")
							.resizable()
							.scaledToFit()
							.frame(dimension: 60)
						Text("🤝")
							.font(.system(size: 40))
						Image("InteracLogo")
							.resizable()
							.scaledToFit()
							.frame(dimension: 54)
						Spacer()
					}
					.padding(.top)
					Spacer(minLength: 0)
				}
				.background(Color.app.secondaryBackground)
			}
			.foregroundColor(Color.app.primaryText)
			.background(Color.app.primaryBackground)
		case .cashOut:
			EmptyView()
		}
	}
}

struct CashOutView_Previews: PreviewProvider {
	static var previews: some View {
		CashOutView(viewModel: .init(context: .onboarding))
	}
}
