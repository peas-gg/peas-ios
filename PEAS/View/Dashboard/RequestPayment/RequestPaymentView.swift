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
				Text("$132.99")
					.font(.system(size: 60, weight: .bold, design: .rounded))
					.foregroundColor(Color.app.secondaryText)
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
				Text("Gia Lopez")
					.font(Font.app.bodySemiBold)
				Text("Will receive an email with the invoice and payment link")
					.padding(.bottom)
				Button(action: {}) {
					Text("Request Payment")
				}
				.buttonStyle(.expanded(style: .darkGreen))
			}
			.font(Font.app.body)
			.foregroundColor(Color.app.darkGreen)
			.padding(.horizontal)
		}
		.background(Color.app.accent)
	}
	
	@ViewBuilder
	func keyView(_ key: String) -> some View {
		Button(action: {}) {
			Rectangle()
				.fill(Color.clear)
				.frame(height: 100)
				.overlay {
					if key == "delete" {
						Image(systemName: "delete.left")
					} else {
						Text(key)
					}
				}
				.opacity(key == "." ? 0.0 : 1.0)
		}
		.font(Font.system(size: 30, weight: .bold, design: .rounded))
		.foregroundColor(Color.app.secondaryText)
	}
}

struct RequestPaymentView_Previews: PreviewProvider {
	static var previews: some View {
		RequestPaymentView(viewModel: .init())
	}
}
