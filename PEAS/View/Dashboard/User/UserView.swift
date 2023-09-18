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
	
	
	var body: some View {
		VStack{
			Spacer()
				.frame(height: SizeConstants.screenSize.height * 0.45)
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
						Image(systemName: "multiply")
							.font(.system(size: 30)) // Adjust font size
							.frame(width: 30, height: 30)
							.foregroundColor(.black)
					} trailing: {
						Button(action: {
							
						}) {
							HStack{
								Image(systemName: "trash")
									.foregroundColor(.white)
								Text("DELETE")
									.font(Font.custom("SF Pro Rounded", size: 11))
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

//					HStack{
//						Button(action: {
//
//						}) {
//							Image(systemName: "multiply")
//								.font(.system(size: 30)) // Adjust font size
//								.frame(width: 30, height: 30)
//								.foregroundColor(.black)
//
//						}
//
//						Spacer()
//
//						Text("Account")
//							.font(Font.app.title2)
//							.foregroundColor(.black)
//
//						Spacer()
//
//						Button(action: {
//
//						}) {
//							HStack{
//								Image(systemName: "trash")
//									.foregroundColor(.white)
//								Text("DELETE")
//									.font(Font.custom("SF Pro Rounded", size: 11))
//									.foregroundColor(.white)
//							}
//							.padding(8)
//							.background(
//								RoundedRectangle(cornerRadius: 15)
//									.fill(Color.black)
//							)
//						}
//						.buttonStyle(PlainButtonStyle())
//					}
//					.padding()
					
					VStack(spacing: 20) {
						textView("Melissa Kournikova")
						textView("mel.kournikova@gmail.com")
						textView("(604) 669-1940")
					}
					.padding(.horizontal)
					
					Text("You can request to edit your account information by tapping the button below")
						.font(Font.custom("SF Pro Rounded", size: 12))
						.multilineTextAlignment(.center)
						.foregroundColor(.black.opacity(0.5))
						.frame(width: 325, alignment: .top)
					
						.padding()
					Spacer()
					
					Button(action: {  }) {
						Text("Request Edit")
					}
					.buttonStyle(.expanded(style: .black))
				}
				.padding(.horizontal)
			}
			
			
			
		}
		.background(.black)
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
