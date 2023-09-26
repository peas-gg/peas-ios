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
	
	@Environment(\.openURL) var openURL
	
	var body: some View {
		switch context {
		case .compact:
			compactView()
		case .detail:
			detailView()
				.presentationDetents([.height(240)])
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
					Button(action: { openMessage() }) {
						Image("Chat")
							.resizable()
							.frame(dimension: 24)
					}
					avatarButton(title: "phone") {
						openPhone()
					}
					avatarButton(title: "envelope") {
						openEmail()
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
			VStack(spacing: 30) {
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
					Button(action: { openMessage() }) {
						Image("Chat")
							.resizable()
							.frame(dimension: context == .detail ? 34 : 24)
					}
					Spacer(minLength: 0)
					avatarButton(title: "phone") {
						openPhone()
					}
					Spacer(minLength: 0)
					avatarButton(title: "envelope") {
						openEmail()
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
	
	func openMessage() {
		if let url = URL(string: "sms:\(customer.phone)") {
			openURL(url)
		}
	}
	
	func openPhone() {
		if let url = URL(string: "tel:\(customer.phone)") {
			openURL(url)
		}
	}
	
	func openEmail() {
		if let url = URL(string: "mailto:\(customer.email)") {
			openURL(url)
		}
	}
}

struct CustomerView_Previews: PreviewProvider {
	static var previews: some View {
		CustomerView(customer: Customer.mock1, context: .compact)
		CustomerView(customer: Customer.mock1, context: .detail)
	}
}
