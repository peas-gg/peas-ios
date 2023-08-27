//
//  SiteView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct SiteView: View {
	@StateObject var viewModel: ViewModel
	
	var backgroundColour: Color {
		let colorHex: String? = viewModel.colours[viewModel.business.color]
		if let colorHex = colorHex {
			return Color(uiColor: UIColor(hex: colorHex))
		}
		return Color.white
	}
	
	var business: Business {
		viewModel.business
	}
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack {
				VStack(alignment: .leading) {
					HStack {
						Image("SiteLogo")
							.resizable()
							.scaledToFit()
							.frame(dimension: 40)
						labelContainer {
							Text("/\(business.sign)")
								.font(Font.app.title2)
						}
					}
					.padding(.bottom, 30)
					HStack(alignment: .top) {
						CachedAvatar(url: business.profilePhoto, height: 60)
						VStack(alignment: .leading) {
							labelContainer {
								Text("\(business.name)")
									.font(Font.app.title2Display)
							}
							HStack {
								ScrollView(.horizontal, showsIndicators: false) {
									HStack {
										ForEach(Array(viewModel.colours.keys), id: \.self) { colorName in
											colorButton(colorName: colorName)
										}
									}
								}
								linksButton()
							}
						}
						.padding(.top, 4)
					}
					labelContainer {
						Text(business.description)
							.font(.system(size: FontSizes.body, weight: .regular, design: .default))
					}
					labelContainer {
						HStack {
							Image(systemName: "mappin.and.ellipse")
								.font(Font.app.bodySemiBold)
							Text(business.location)
								.font(.system(size: FontSizes.body, weight: .semibold, design: .default))
						}
					}
					.padding(.vertical, 2)
				}
				.padding(.horizontal)
				LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 2), spacing: 15) {
					ForEach(business.blocks) { block in
						blockView(block)
					}
				}
				.padding(14)
				.background {
					Color.white
						.cornerRadius(30, corners: [.topLeft, .topRight])
						.edgesIgnoringSafeArea(.bottom)
				}
				.padding(.top, 10)
			}
		}
		.foregroundColor(Color.app.primaryText)
		.overlay (alignment: .bottom){
			toolbar()
		}
		.background {
			VStack {
				backgroundColour
				Color.white
			}
			.ignoresSafeArea()
			.animation(.easeOut, value: backgroundColour)
		}
	}
	
	@ViewBuilder
	func colorButton(colorName: String) -> some View {
		let color: Color = {
			let colorHex: String? = viewModel.colours[colorName]
			if let colorHex = colorHex {
				return Color(uiColor: UIColor(hex: colorHex))
			}
			return Color.gray
		}()
		let isCurrentColor: Bool = color == backgroundColour
		Button(action: { viewModel.setBackgroundColor(colorName: colorName) }) {
			ZStack {
				Circle()
					.fill(Color.white)
				Circle()
					.fill(color)
					.padding(isCurrentColor ? 2 : 0.2)
			}
			.frame(dimension: 36)
		}
		.buttonStyle(.insideScaling)
	}
	
	@ViewBuilder
	func linksButton() -> some View {
		Button(action: {}) {
			Text("@")
				.font(Font.app.bodySemiBold)
				.padding(8)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.white)
						.frame(dimension: 36)
				)
		}
	}
	
	@ViewBuilder
	func blockView(_ block: Business.Block) -> some View {
		let height: CGFloat = 230
		Button(action: {}) {
			CachedImage(
				url: block.image,
				content: { uiImage in
					Image(uiImage: uiImage)
						.resizable()
						.scaledToFill()
						.frame(maxHeight: height)
						.clipShape(RoundedRectangle(cornerRadius: 20))
				},
				placeHolder: {
					RoundedRectangle(cornerRadius: 20)
						.fill(Color.gray.opacity(0.2))
						.frame(maxHeight: height)
						.overlay(ProgressView())
				}
			)
			.overlay(
				RoundedRectangle(cornerRadius: 20)
					.fill(
						LinearGradient(
							colors: [Color.clear, Color.black.opacity(0.8)],
							startPoint: .top,
							endPoint: .bottom
						)
					)
					.overlay(alignment: .bottom) {
						VStack(alignment: .leading) {
							Text(block.title)
								.font(Font.app.title2)
								.foregroundColor(Color.app.secondaryText)
								.padding(.leading)
							HStack(spacing: 2) {
								Spacer()
								Text("\(block.duration.timeSpan)")
									.font(.system(size: FontSizes.footnote, weight: .medium, design: .rounded))
									.foregroundColor(Color.gray)
									.padding([.horizontal, .bottom])
							}
						}
					}
					.overlay(alignment: .topTrailing) {
						Text("$\(block.price, specifier: "%.2f")")
							.font(Font.app.bodySemiBold)
							.padding(.horizontal, 6)
							.padding(.vertical, 10)
							.background(
								RoundedRectangle(cornerRadius: 10)
									.fill(Color.white)
							)
							.padding([.top, .trailing], 10)
					}
			)
		}
		.buttonStyle(.bright)
	}
	
	@ViewBuilder
	func toolbar() -> some View {
		HStack(spacing: 30) {
			if viewModel.isInEditMode {
				Button(action: { viewModel.toggleEditMode() }) {
					toolbarImage("xmark")
				}
			} else {
				Button(action: {}) {
					toolbarImage("globe")
				}
				Button(action: {}) {
					toolbarImage("calendar.badge.clock")
				}
				Button(action: { viewModel.toggleEditMode() }) {
					toolbarImage("pencil")
				}
			}
		}
		.transition(.asymmetric(insertion: .scale, removal: .identity))
		.font(.system(size: FontSizes.title2))
		.foregroundColor(Color.black)
		.padding()
		.background {
			ZStack {
				Capsule()
					.fill(.bar)
				Capsule()
					.stroke(Color.white, lineWidth: 1)
			}
		}
		.animation(.easeInOut, value: viewModel.isInEditMode)
	}
	
	@ViewBuilder
	func toolbarImage(_ imageName: String) -> some View {
		Image(systemName: imageName)
			.frame(dimension: 20.0)
	}
	
	@ViewBuilder
	func labelContainer<Content: View>(content: () -> Content) -> some View {
		Button(action: {}) {
			content()
				.padding(.vertical, 8)
				.padding(.horizontal, 8)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.white.opacity(viewModel.isInEditMode ? 0.5 : 0.0))
						.animation(.easeInOut, value: viewModel.isInEditMode)
				)
		}
		.disabled(!viewModel.isInEditMode)
	}
}

struct SiteView_Previews: PreviewProvider {
	static var previews: some View {
		SiteView(viewModel: .init(isTemplate: true, business: Business.mock1))
	}
}
