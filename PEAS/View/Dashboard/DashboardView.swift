//
//  DashboardView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct DashboardView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		VStack {
			VStack(spacing: 20) {
				HStack {
					VStack (alignment: .leading){
						Text("Welcome,")
							.foregroundColor(Color.app.tertiaryText)
						Text(viewModel.user.firstName)
							.foregroundColor(Color.app.primaryText)
							.lineLimit(1)
					}
					.font(.system(size: FontSizes.title1, weight: .semibold, design: .rounded))
					Spacer(minLength: 0)
					Button(action: {}) {
						CachedAvatar(
							url: viewModel.business.profilePhoto,
							height: SizeConstants.avatarHeight + 10
						)
					}
				}
				.padding(.top, 30)
				Text("$2,378.56")
					.foregroundColor(.green)
					.font(.system(size: 50, weight: .semibold, design: .rounded))
				HStack {
					Spacer()
					buttonView(symbol: "dollarsign.circle", title: "CashOut") {
						
					}
					Spacer()
						.frame(width: 20)
					buttonView(symbol: "doc.text", title: "Transactions") {
						
					}
					Spacer()
				}
			}
			.padding(.horizontal)
			.padding(.horizontal, 10)
			VStack {
				VStack {
					HStack {
						Text("Services (7 pending)")
							.font(Font.app.bodySemiBold)
						Spacer()
						if let selectedOrderFilter = viewModel.selectedOrderFilter {
							filterIndicator(filter: selectedOrderFilter)
						}
						Button(action: {}) {
							Image(systemName: viewModel.selectedOrderFilter == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
						}
					}
					Divider()
					ScrollView {
						LazyVStack {
							OrderView(viewModel: .init(context: .dashboard, order: Order.mock1))
							OrderView(viewModel: .init(context: .dashboard, order: Order.mock1))
						}
						.padding(.top, 10)
					}
				}
				.padding()
			}
			.background {
				Color.app.primaryBackground
					.cornerRadius(10, corners: [.topLeft, .topRight])
			}
			.edgesIgnoringSafeArea(.bottom)
			.padding(.horizontal, 10)
			.padding(.top)
			Spacer(minLength: 0)
		}
		.foregroundColor(Color.app.primaryText)
		.background(Color.app.secondaryBackground)
	}
	
	@ViewBuilder
	func buttonView(symbol: String, title: String, action: @escaping () -> ()) -> some View {
		Button(action: { action() }) {
			HStack {
				Image(systemName: symbol)
				Text(title)
			}
			.font(Font.app.bodySemiBold)
			.foregroundColor(Color.app.primaryText)
			.padding(10)
			.background {
				RoundedRectangle(cornerRadius: 10)
					.fill(Color.white)
			}
		}
	}
	
	@ViewBuilder
	func filterIndicator(filter: Order.Status) -> some View {
		ZStack {
			Circle()
				.fill(filter.backgroundColor)
			Circle()
				.stroke(filter.foregroundColor)
		}
		.frame(dimension: 15)
	}
}

struct DashboardView_Previews: PreviewProvider {
	static var previews: some View {
		DashboardView(viewModel: .init(user: User.mock1, business: Business.mock1))
	}
}
