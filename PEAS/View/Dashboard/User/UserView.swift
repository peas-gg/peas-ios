//
//  UserView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-11.
//

import PhoneNumberKit
import SwiftUI

struct UserView: View {
	@StateObject var viewModel: ViewModel
	
	let phoneNumberKit: PhoneNumberKit = PhoneNumberKit()
	
	@Environment(\.openURL) var openURL
	
	init(viewModel: ViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}
	
	var body: some View {
		VStack {
			VStack(spacing: 10) {
				SymmetricHStack(
					content: {
						Text("Account")
							.font(Font.app.title2)
							.foregroundColor(.black)
					}, leading: {
						EmptyView()
					}, trailing: {
						Button(action: { openEmail() }) {
							Image(systemName: "trash")
							Text("delete")
								.font(Font.app.captionSemiBold)
								.textCase(.uppercase)
						}
						.padding(6)
						.background(CardBackground(style: .lightGray))
					}
				)
				.padding(.vertical)
				textView(viewModel.user.firstName)
				textView(viewModel.user.lastName)
				textView(viewModel.user.email)
				if let interacEmail = viewModel.user.interacEmail {
					textView(interacEmail, isInterac: true)
				}
				if let phoneNumber = try? phoneNumberKit.parse(viewModel.user.phone) {
					let formattedPhoneNumber = phoneNumberKit.format(phoneNumber, toType: .national)
					textView(formattedPhoneNumber)
				} else {
					textView(viewModel.user.phone)
				}
			}
			.padding(.horizontal)
			.padding(.horizontal)
			Spacer(minLength: 0)
			Button(action: { viewModel.requestLogOut() }) {
				Text("Log out")
					.font(Font.app.title2Display)
					.underline()
					.padding(.horizontal)
			}
			Button(action: { openEmail() }) {
				Text("Request edit")
			}
			.buttonStyle(.expanded)
			.padding(.horizontal)
		}
		.foregroundColor(Color.app.primaryText)
		.presentationDetents([.height(SizeConstants.detentHeight + 100)])
		.alert(isPresented: $viewModel.isShowingLogOutAlert) {
			Alert(
				title: Text("Are you sure you would like to logout?"),
				primaryButton: .destructive(Text("Logout")) { viewModel.logOut() },
				secondaryButton: .cancel()
			)
		}
	}
	
	@ViewBuilder
	func textView(_ content: String, isInterac: Bool = false) -> some View {
		let interacImageDimension: CGFloat = 30
		HStack{
			Image(systemName: "lock")
			Text(content)
				.font(Font.app.bodySemiBold)
				.lineLimit(1)
			Spacer(minLength: interacImageDimension)
		}
		.foregroundColor(Color.app.tertiaryText)
		.padding()
		.background(CardBackground())
		.overlay(isShown: isInterac, alignment: .trailing) {
			Image("Interac")
				.resizable()
				.scaledToFit()
				.frame(dimension: interacImageDimension)
				.padding(.trailing)
				.offset(x: 4)
		}
	}
	
	func openEmail() {
		if let url = URL(string: "mailto:hello@peas.gg") {
			openURL(url)
		}
	}
}

struct UserView_Previews: PreviewProvider {
	static var previews: some View {
		UserView(viewModel: .init(user: User.mock1))
	}
}
