//
//  UserView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-11.
//

import SwiftUI

struct UserView: View {
	@StateObject var viewModel: ViewModel
	@State private var username = ""
	@State private var email = ""
	@State private var phoneNumber = ""
	let detentHeight: CGFloat = 400
	let userObject: User
	
	init(viewModel: ViewModel, userObject: User) {
		self._viewModel = StateObject(wrappedValue: viewModel)
		self.userObject = user
	}
	
	
	
	var body: some View {
		VStack{
			ZStack{
				Rectangle()
					.foregroundColor(Color(red: 0.98, green: 0.98, blue: 0.98))
					.frame(maxHeight: .infinity)
					.background(Color(red: 0.98, green: 0.98, blue: 0.98))
					.cornerRadius(15)
					.ignoresSafeArea()
				VStack{
					SymmetricHStack {
						Text("Account")
							.font(Font.app.title2)
							.foregroundColor(.black)
					} leading: {
						EmptyView()
					} trailing: {
						Button(action: {
						}) {
							HStack{
								Image(systemName: "trash")
									.foregroundColor(.white)
								Text("DELETE")
									.font(Font.app.caption)
									.foregroundColor(.white)
							}
							.padding(8)
							.background(
								RoundedRectangle(cornerRadius: 15)
									.fill(Color.black)
							)
						}
						.buttonStyle(PlainButtonStyle())
					}
					.padding()
					VStack(spacing: 20) {
						textView("\(user.firstName) \(user.lastName)")
						textView(user.email)
						textView(user.phone)
					}
					.padding(.horizontal)
					Text("You can request to edit your account information by tapping the button below")
						.font(Font.app.footnote)
						.multilineTextAlignment(.center)
						.foregroundColor(.black.opacity(0.5))
						.frame(width: 325, alignment: .top)
						.padding()
					Button(action: {  }) {
						Text("Request Edit")
					}
					.buttonStyle(.expanded(style: .black))
				}
				.padding(.horizontal)
			}
		}
		.presentationDetents([.height(detentHeight)])
	}
	
	@ViewBuilder
	func textView(_ content: String) -> some View {
		HStack{
			Text(content)
				.font(Font.app.bodySemiBold)
				.foregroundColor(Color.app.tertiaryText)
			Spacer(minLength: 0)
		}
		.padding()
		.background(Textbackground())
	}
}

struct UserView_Previews: PreviewProvider {
	static var previews: some View {
		UserView(viewModel: .init())
	}
}
