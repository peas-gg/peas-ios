//
//  RequestPaymentView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-12.
//

import SwiftUI

struct RequestPaymentView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		VStack {
			HStack {
				Spacer()
				Capsule()
					.fill(Color.white)
					.frame(width: 40, height: 6)
				Spacer()
			}
			.padding(.top, 20)
			Spacer(minLength: 0)
			HStack {
				Spacer(minLength: 0)
				let fontSize: CGFloat = {
					let count: Int = viewModel.priceText.count
					if count <= 7 {
						return 60
					} else if count <= 9 {
						return 50
					} else {
						return 45
					}
				}()
				HStack {
					Text("$")
					Text("\(PriceFormatter.price(value: viewModel.priceText))")
						.lineLimit(1)
				}
				.font(.system(size: fontSize, weight: .bold, design: .rounded))
				.foregroundColor(Color.app.secondaryText)
				.frame(height: 160)
				Spacer(minLength: 0)
			}
			Spacer(minLength: 0)
			LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
				ForEach(viewModel.keypad, id: \.self) { key in
					keyView(key)
				}
			}
			Spacer(minLength: 0)
			VStack(spacing: 10) {
				Text(viewModel.order.customer.fullName)
					.font(Font.app.bodySemiBold)
				Text("Payment link will be sent to \n \(viewModel.order.customer.email) \n")
					.multilineTextAlignment(.center)
					.fixedSize(horizontal: false, vertical: true)
					.padding(.bottom)
				Button(action: { viewModel.request() }) {
					Text("Request Payment")
				}
				.buttonStyle(.expanded(style: .darkGreen))
			}
			.font(Font.app.body)
			.foregroundColor(Color.app.darkGreen)
			.padding(.horizontal)
			.padding(.bottom, SizeConstants.isSmallPhone ? 20 : 0)
		}
		.background(Color.app.accent)
		.banner(data: $viewModel.bannerData)
		.progressView(isShowing: viewModel.isLoading, style: .green)
	}
	
	@ViewBuilder
	func keyView(_ key: String) -> some View {
		Button(action: { viewModel.keyTapped(key: key) }) {
			Rectangle()
				.fill(Color.clear)
				.frame(height: SizeConstants.isSmallPhone ? 70 : 100)
				.overlay {
					if key == AppConstants.keypadDelete {
						Image(systemName: "delete.left")
					} else {
						Text(key)
					}
				}
				.opacity(key == "." ? 0.0 : 1.0)
		}
		.font(Font.system(size: 30, weight: .bold, design: .rounded))
		.foregroundColor(Color.app.secondaryText)
		.buttonStyle(.keypad)
	}
}

struct RequestPaymentView_Previews: PreviewProvider {
	static var previews: some View {
		RequestPaymentView(viewModel: .init(business: Business.mock1, order: Order.mock1))
	}
}
