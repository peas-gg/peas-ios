//
//  CustomersView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

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
			VStack {
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
					.padding(.bottom, 4)
					if viewModel.customers.count == 0 {
						VStack {
							Spacer()
							Text("Your customers contacts will go here")
								.font(Font.app.body)
								.foregroundColor(Color.app.tertiaryText)
							Spacer()
						}
					} else {
						ScrollView {
							Spacer()
								.frame(height: 20)
							LazyVStack(spacing: 20) {
								ForEach(viewModel.customers.indices, id: \.self) { index in
									customerView(customer: viewModel.customers[index])
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
						}
					}
				}
				.padding([.top, .horizontal])
				Spacer(minLength: 0)
			}
			.background(Color.app.secondaryBackground)
		}
		.banner(data: $viewModel.customerRepository.bannerData)
		.progressView(isShowing: viewModel.customerRepository.isLoading, style: .white)
		.onAppear { viewModel.refresh() }
	}
	
	@ViewBuilder
	func customerView(customer: Customer) -> some View {
		HStack {
			avatar(customer: customer)
			VStack(alignment: .leading) {
				Text("\(customer.firstName) \(customer.lastName)")
					.font(Font.app.bodySemiBold)
					.foregroundColor(Color.app.primaryText)
					.lineLimit(1)
				HStack(spacing: 30) {
					Button(action: {}) {
						Image("chat")
							.resizable()
							.frame(dimension: 24)
					}
					avatarButton(title: "phone") {
						
					}
					avatarButton(title: "envelope") {
						
					}
				}
				.foregroundColor(Color.app.tertiaryText)
			}
			Spacer(minLength: 0)
		}
	}
	
	@ViewBuilder
	func avatar(customer: Customer) -> some View {
		let size: CGSize = CGSize(width: 50, height: 60)
		RoundedRectangle(cornerRadius: size.width)
			.fill(customer.color.opacity(0.5))
			.frame(size: size)
			.overlay(
				Text(customer.initial)
					.font(Font.app.title2Display)
					.foregroundColor(Color.app.primaryText)
			)
	}
	
	@ViewBuilder
	func avatarButton(title: String, action: @escaping () -> ()) -> some View {
		Button(action: { action() }) {
			Image(systemName: title)
				.font(.system(size: 20, weight: .bold))
		}
	}
}

struct CustomersView_Previews: PreviewProvider {
	static var previews: some View {
		CustomersView(viewModel: .init())
	}
}
