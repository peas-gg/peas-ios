//
//  SiteView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct SiteView: View {
	let profileTextHeight: CGFloat = 38
	let blockHeight: CGFloat = SizeConstants.screenSize.height / 3.5
	let linksMenuId: String = "LinksMenu"
	
	@StateObject var viewModel: ViewModel
	
	@Environment(\.openURL) var openURL
	
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
					HStack(spacing: 0) {
						Image("SiteLogo")
							.resizable()
							.scaledToFit()
							.frame(dimension: 40)
						labelContainer(action: { viewModel.setEditModeContext(.sign) }) {
							Group {
								if business.sign.isEmpty {
									hintText("Peas sign")
								} else {
									Text("/\(business.sign)")
								}
							}
							.font(Font.app.title2)
							.textCase(.lowercase)
						}
					}
					.padding(.bottom, 30)
					HStack(alignment: .center) {
						Button(action: {
							if viewModel.isInEditMode {
								viewModel.setEditModeContext(.photo)
							}
						}) {
							CachedAvatar(url: business.profilePhoto, height: SizeConstants.avatarHeight)
								.overlay(isShown: viewModel.isInEditMode) {
									RoundedRectangle(cornerRadius: 50)
										.fill(Color.black.opacity(0.6))
										.overlay {
											Image(systemName: "square.on.square.intersection.dashed")
												.font(Font.app.bodySemiBold)
												.foregroundColor(Color.app.secondaryText)
										}
								}
						}
						.background {
							RoundedRectangle(cornerRadius: 50)
								.fill(Color.white.opacity(0.2))
								.padding(-4)
								.opacity(viewModel.isInEditMode ? 1.0 : 0.0)
						}
						.buttonStyle(.plain)
						VStack(alignment: .leading) {
							labelContainer(action: { viewModel.setEditModeContext(.name) }) {
								Group {
									if business.name.isEmpty {
										hintText("Business Name")
									} else {
										Text("\(business.name)")
									}
								}
								.font(Font.app.title2Display)
							}
							HStack {
								if viewModel.isInEditMode {
									ScrollView(.horizontal, showsIndicators: false) {
										HStack {
											ForEach(Array(viewModel.colours.keys), id: \.self) { colorName in
												colorButton(colorName: colorName)
											}
										}
									}
								} else {
									HStack {
										Image(systemName: "person.crop.circle.badge.checkmark")
										Text("0")
									}
									.font(Font.app.bodySemiBold)
									.foregroundColor(Color.app.primaryText)
									.padding(.horizontal)
									.background(
										RoundedRectangle(cornerRadius: SizeConstants.textCornerRadius)
											.fill(Color.white.opacity(viewModel.isInEditMode ? 0.5 : 1.0))
											.frame(height: profileTextHeight)
									)
									.padding(.horizontal, 8)
								}
								linksButton()
								Spacer(minLength: 0)
							}
						}
						.padding(.top, 4)
					}
					labelContainer(action: { viewModel.setEditModeContext(.description) }) {
						Group {
							if business.description.isEmpty {
								hintText("Business Description")
							} else {
								Text(business.description)
							}
						}
						.font(.system(size: FontSizes.body, weight: .regular, design: .default))
						.multilineTextAlignment(.leading)
					}
					labelContainer(action: { viewModel.setEditModeContext(.location) }) {
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
					if viewModel.isInEditMode {
						Button(action: { viewModel.setEditModeContext(.block(nil)) }) {
							ZStack {
								RoundedRectangle(cornerRadius: SizeConstants.blockCornerRadius)
									.fill(Color.white.opacity(0.2))
								RoundedRectangle(cornerRadius: SizeConstants.blockCornerRadius)
									.stroke(Color.white, lineWidth: 2)
							}
							.overlay(
								Image(systemName: "plus.circle.fill")
									.font(Font.app.largeTitle)
									.foregroundColor(Color.app.secondaryText)
							)
						}
						.frame(height: blockHeight)
						.buttonStyle(.plain)
					}
				}
				.padding(14)
				.background {
					Color.white.opacity(viewModel.isInEditMode ? 0.0 : 1.0)
						.cornerRadius(30, corners: [.topLeft, .topRight])
						.edgesIgnoringSafeArea(.bottom)
				}
				.padding(.top, 10)
				.padding(.bottom, SizeConstants.scrollViewBottomPadding)
			}
		}
		.foregroundColor(Color.app.primaryText)
		.overlay (alignment: .bottom){
			toolbar()
				.padding(.bottom)
		}
		.background {
			VStack {
				backgroundColour
				if !viewModel.isInEditMode {
					Color.white
						.frame(height: SizeConstants.screenSize.height * 0.4)
				}
			}
			.ignoresSafeArea()
			.animation(.easeOut, value: backgroundColour)
		}
		.appMenu(id: linksMenuId, isShowing: $viewModel.isShowingSocialLinksMenu) {
			VStack {
				if let twitter = getSocialLink(handle: business.twitter) {
					socialLink(title: "X", link: "\(AppConstants.twitterUrlString + twitter)")
				}
				if let instagram = getSocialLink(handle: business.instagram) {
					socialLink(title: "Instagram", link: "\(AppConstants.instagramUrlString + instagram)")
				}
				if let tiktok = getSocialLink(handle: business.tiktok) {
					socialLink(title: "Tiktok", link: "\(AppConstants.tiktokUrlString + tiktok)")
				}
				if !viewModel.hasSocialLink {
					Text("Go into edit mode to add a link")
						.font(Font.app.body)
						.foregroundColor(Color.app.primaryText)
				}
			}
			.padding()
			.frame(width: 200)
		}
		.sheet(
			isPresented: Binding(
				get: { return viewModel.editModeContext != nil },
				set: { value in
					if value == false {
						viewModel.setEditModeContext(nil)
					}
				}
			)
		) {
			if let context = viewModel.editModeContext {
				EditSiteView(
					viewModel: .init(
						isTemplate: viewModel.isTemplate,
						business: viewModel.business,
						context: context,
						onSave: { business in
							viewModel.dismissEditContext(business)
						}
					)
				)
			}
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
		Button(action: {
			if viewModel.isInEditMode {
				viewModel.setEditModeContext(.links)
			} else {
				viewModel.showSocialLinks()
			}
		}) {
			Text("@")
				.font(Font.app.bodySemiBold)
				.padding(8)
				.background(
					RoundedRectangle(cornerRadius: SizeConstants.textCornerRadius)
						.fill(Color.white.opacity(viewModel.isInEditMode ? 0.5 : 1.0))
						.frame(dimension: profileTextHeight)
				)
				.animation(.easeInOut, value: viewModel.isInEditMode)
		}
		.anchorPreference(key: BoundsPreferenceKey.self, value: .bounds) { [linksMenuId : $0] }
	}
	
	@ViewBuilder
	func blockView(_ block: Business.Block) -> some View {
		let cornerRadius: CGFloat = SizeConstants.blockCornerRadius
		Button(action: {
			if viewModel.isInEditMode {
				viewModel.setEditModeContext(.block(block.id))
			}
		}) {
			CachedImage(
				url: block.image,
				content: { uiImage in
					Image(uiImage: uiImage)
						.resizable()
						.scaledToFill()
						.frame(minWidth: 160)
						.frame(height: blockHeight)
						.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
				},
				placeHolder: {
					RoundedRectangle(cornerRadius: cornerRadius)
						.fill(Color.gray.opacity(0.2))
						.frame(height: blockHeight)
				}
			)
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(
						LinearGradient(
							colors: [Color.clear, Color.clear,  Color.black.opacity(0.8)],
							startPoint: .top,
							endPoint: .bottom
						)
					)
					.overlay(alignment: .bottom) {
						VStack(alignment: .leading) {
							Text(block.title)
								.font(Font.app.title2)
								.multilineTextAlignment(.leading)
								.foregroundColor(Color.app.secondaryText)
								.padding(.leading)
							HStack(spacing: 2) {
								Spacer()
								Text("\(block.duration.timeSpan)")
									.font(Font.app.bodySemiBold)
									.foregroundColor(Color.gray)
									.padding([.horizontal, .bottom])
							}
						}
					}
					.overlay(alignment: .topTrailing) {
						Text("$\(PriceFormatter.price(value: String(block.price)))")
							.font(Font.app.bodySemiBold)
							.padding(.horizontal, 6)
							.padding(.vertical, 10)
							.background(
								RoundedRectangle(cornerRadius: SizeConstants.textCornerRadius)
									.fill(Color.white)
							)
							.padding([.top, .trailing], 10)
					}
			)
			.overlay(isShown: viewModel.isInEditMode) {
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(Color.black.opacity(0.5))
					.overlay {
						HStack{
							Image(systemName: "square.on.square.intersection.dashed")
							Text("Edit")
						}
						.font(Font.app.title2Display)
						.foregroundColor(Color.app.secondaryText)
					}
			}
			.id(block.image)
		}
		.background(
			RoundedRectangle(cornerRadius: cornerRadius)
				.fill(Color.white.opacity(viewModel.isInEditMode ? 0.5 : 0.0))
				.padding(-5)
		)
		.buttonStyle(.plain)
	}
	
	@ViewBuilder
	func toolbar() -> some View {
		HStack(spacing: 30) {
			if viewModel.isInEditMode {
				Button(action: { viewModel.toggleEditMode() }) {
					toolbarImage("xmark")
				}
			} else {
				Group {
					Button(action: {
						if let url = viewModel.siteUrl {
							openURL(url)
						}
					}) {
						toolbarImage("globe")
					}
					Button(action: { viewModel.setEditModeContext(.schedule) }) {
						toolbarImage("calendar.badge.clock")
					}
				}
				.disabled(viewModel.isTemplate)
				.opacity(viewModel.isTemplate ? 0.5 : 1.0)
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
	func labelContainer<Content: View>(action: @escaping () -> (), content: () -> Content) -> some View {
		Button(action: { action() }) {
			content()
				.padding(.vertical, 8)
				.padding(.horizontal, 8)
				.background(
					RoundedRectangle(cornerRadius: SizeConstants.textCornerRadius)
						.fill(Color.white.opacity(viewModel.isInEditMode ? 0.5 : 0.0))
						.animation(.easeInOut, value: viewModel.isInEditMode)
				)
		}
		.disabled(!viewModel.isInEditMode)
	}
	
	@ViewBuilder
	func socialLink(title: String, link: String) -> some View {
		if let url = URL(string: link) {
			Button(action: { openURL(url) }) {
				HStack {
					Text("\(title)")
						.font(Font.app.body)
					Spacer()
					Image(title)
						.resizable()
						.scaledToFit()
						.frame(dimension: 24)
				}
				.foregroundColor(Color.app.primaryText)
			}
		}
	}
	
	@ViewBuilder
	func hintText(_ text: String) -> some View {
		Text(text)
			.opacity(0.2)
	}
	
	func getSocialLink(handle: String?) -> String? {
		if let handle = handle {
			if handle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
				return nil
			} else {
				return handle
			}
		} else {
			return nil
		}
	}
}

struct SiteView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			SiteView(viewModel: .init(isTemplate: false, business: Business.mock1))
		}
	}
}
