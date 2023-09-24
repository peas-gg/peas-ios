//
//  CustomerView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-23.
//

import SwiftUI

struct CustomerView: View {
	enum Context {
		case detail
		case compact
	}
	
	let customer: Customer
	let context: Context
	
	var body: some View {
		switch context {
		case .compact:
			compactView()
		case .detail:
			detailView()
		}
	}
	
	@ViewBuilder
	func compactView() -> some View {
		HStack {
			avatar()
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
	func detailView() -> some View {
		VStack(spacing: 20) {
			avatar()
			VStack(alignment: .leading) {
				HStack {
					Spacer()
					Text("\(customer.firstName) \(customer.lastName)")
						.font(Font.app.title2)
						.foregroundColor(Color.app.primaryText)
						.lineLimit(1)
					Spacer()
				}
				HStack(spacing: 30) {
					Spacer(minLength: 0)
					Button(action: {}) {
						Image("chat")
							.resizable()
							.frame(dimension: context == .detail ? 34 : 24)
					}
					Spacer(minLength: 0)
					avatarButton(title: "phone") {
						
					}
					Spacer(minLength: 0)
					avatarButton(title: "envelope") {
						
					}
					Spacer(minLength: 0)
				}
				.foregroundColor(Color.app.tertiaryText)
			}
		}
	}
	
	@ViewBuilder
	func avatar() -> some View {
		let size: CGSize = {
			switch context {
			case .detail: return CGSize(width: 60, height: 80)
			case .compact: return CGSize(width: 50, height: 60)
			}
		}()
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
				.font(.system(size: context == .detail ? 30 : 20, weight: .bold))
		}
	}
}

struct CustomerView_Previews: PreviewProvider {
	static var previews: some View {
		CustomerView(customer: Customer.mock1, context: .compact)
		CustomerView(customer: Customer.mock1, context: .detail)
	}
}
