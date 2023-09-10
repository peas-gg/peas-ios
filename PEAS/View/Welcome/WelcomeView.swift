//
//  WelcomeView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import SwiftUI

struct WelcomeView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		ZStack{
			VStack {
				HStack{
					Spacer()
					Text(viewModel.currentPage.pageTitle)
						.font(Font.custom("DaysOne-Regular", size: 30))
						.foregroundColor(.white)
						.multilineTextAlignment(.center)
					Spacer()
				}
				.padding(.top)
				Spacer()
			}
			VStack {
				TabView(selection: $viewModel.currentPage) {
					ForEach(ViewModel.Page.allCases) { page in
						VStack{
							imageView(page: page)
						}
						.tag(page)
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.edgesIgnoringSafeArea(.all)
				.onAppear { UIScrollView.appearance().bounces = false }
			}
			VStack {
				Spacer()
				Text("Start treating your side hustle as a business")
					.font(Font.app.body)
					.foregroundColor(Color.app.tertiaryText)
					.padding(.bottom, 40)
				Button(action: {}) {
					Text("Login")
						.font(Font.app.title2Display)
						.foregroundColor(Color.app.secondaryText)
						.underline()
				}
				.padding(.bottom)
				Button(action: {}) {
					Text("Start")
				}
				.buttonStyle(.expanded(style: .white))
				.padding(.horizontal)
			}
			.multilineTextAlignment(.center)
		}
		.background(background())
		.animation(.easeOut.speed(2.0), value: viewModel.currentPage)
	}
	
	@ViewBuilder
	func imageView(page: ViewModel.Page) -> some View {
		ZStack {
			switch page {
			case .createSite, .acceptPayment:
				Image(page.pageImage)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: SizeConstants.screenSize.width * 0.7, height: SizeConstants.screenSize.height * 0.8)
			case .dropLink:
				Image(page.pageImage)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(height: SizeConstants.screenSize.height * 0.7)
			}
			VStack {
				Spacer()
				VStack{
					Rectangle()
						.fill(
							LinearGradient(
								colors: [
									Color.clear,
									Color.black.opacity(0.8),
									Color.black,
									Color.black,
								],
								startPoint: .top,
								endPoint: .bottom
							)
						)
						.frame(height: SizeConstants.screenSize.height * 0.40)
				}
			}
		}
	}
	
	@ViewBuilder
	func background() -> some View {
		ZStack {
			VStack {
				Rectangle()
					.fill(
						AngularGradient(
							colors: viewModel.currentPage.pageColors,
							center: .center,
							angle: .degrees(270)
						)
					)
					.frame(maxHeight: 340)
					.blur(radius: 50)
					.padding(.top)
				Spacer()
			}
			.background(Color.black)
			VStack{
				LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 5), spacing: 0) {
					ForEach(0..<30) {
						Rectangle()
							.stroke(Color.white.opacity(0.1))
							.frame(minHeight: 80)
							.id($0)
					}
				}
				.overlay(alignment: .top) {
					Rectangle()
						.fill(
							LinearGradient(
								colors: [
									Color.black,
									Color.black.opacity(0.8),
									Color.black.opacity(0.4),
									Color.clear
								],
								startPoint: .top,
								endPoint: .bottom
							)
						)
						.frame(height: 180)
						.edgesIgnoringSafeArea(.top)
				}
				.overlay(alignment: .bottom) {
					let height: CGFloat = 80
					Rectangle()
						.fill(
							LinearGradient(
								colors: [
									Color.clear,
									Color.black.opacity(0.2),
									Color.black.opacity(0.4),
									Color.black.opacity(0.8),
									Color.black
								],
								startPoint: .top,
								endPoint: .bottom
							)
						)
						.frame(height: height)
						.offset(y: 10)
						.edgesIgnoringSafeArea(.top)
				}
				Spacer()
			}
		}
	}
}

struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView(viewModel: .init(onboardingVM: .init()))
	}
}
