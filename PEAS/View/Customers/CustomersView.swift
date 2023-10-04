//
//  CustomersView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import IdentifiedCollections
import SwiftUI

struct CustomersView: View {
	let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}()
	
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		VStack(spacing: 0) {
			Text("Customers")
				.font(Font.app.title2)
				.foregroundColor(Color.app.primaryText)
				.padding(.top)
			Divider()
				.padding(.top)
			VStack(spacing: 0) {
				HStack {
					let numberOfCustomers: String = {
						return numberFormatter.string(from: viewModel.customers.count as NSNumber) ?? String(viewModel.customers.count)
					}()
					Text(numberOfCustomers)
					Text("customers")
					Spacer()
				}
				.font(Font.app.title2Display)
				.padding()
				ScrollView {
					VStack(spacing: 0) {
						if viewModel.customers.count == 0 {
							VStack {
								Spacer()
								Text("Your customers contacts will go here")
									.font(Font.app.body)
									.foregroundColor(Color.app.tertiaryText)
								Spacer()
							}
						} else {
							LazyVStack(spacing: 20) {
								ForEach(viewModel.customers.indices, id: \.self) { index in
									CustomerView(customer: viewModel.customers[index], context: .compact)
									if index != viewModel.customers.count - 1 {
										Divider()
									}
								}
							}
							.padding()
							.background {
								RoundedRectangle(cornerRadius: 10)
									.fill(Color.app.primaryBackground)
							}
							.padding(.bottom, SizeConstants.scrollViewBottomPadding)
						}
					}
					.padding([.top, .horizontal])
				}
				Spacer(minLength: 0)
			}
			.background(Color.app.secondaryBackground)
		}
		.banner(data: $viewModel.bannerData)
		.progressView(isShowing: viewModel.isLoading, style: .white)
		.onAppear { viewModel.refresh() }
		.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
			viewModel.refresh()
		}
	}
}

struct CustomersView_Previews: PreviewProvider {
	static var previews: some View {
		CustomersView(viewModel: .init(business: Business.mock1, customers: IdentifiedArray(uniqueElements: [Customer.mock1, Customer.mock2])))
	}
}
