//
//  EditSiteView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-27.
//

import SwiftUI

struct EditSiteView: View {
	@StateObject var viewModel: EditSiteView.ViewModel
	
	enum FocusField: Hashable {
		case sign
		case name
		case description
		case blockPrice
	}
	
	let textfieldVerticalPadding: CGFloat = 12
	
	@FocusState private var focusedField: FocusField?
	
	@State var isPriceKeyboardFocused: Bool = false
	
	init(viewModel: EditSiteView.ViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}
	
	var body: some View {
		VStack(spacing: 0) {
			let horizontalPadding: CGFloat = 25
			Text(viewModel.context.title)
				.font(Font.app.title2)
				.foregroundColor(Color.app.primaryText)
				.padding(.top)
			Divider()
				.padding(.top)
			VStack {
				let spacing: CGFloat = 20
				switch viewModel.context {
				case .photo:
					VStack(alignment: .center, spacing: spacing) {
						hintText(content: "Think of your business photo as your brand image")
						HStack {
							Spacer()
							Button(action: {}) {
								CachedAvatar(url: viewModel.photo, height: 200)
									.overlay {
										Image(systemName: "photo")
											.font(Font.app.largeTitle)
											.foregroundColor(Color.app.tertiaryText)
									}
							}
							.buttonStyle(.plain)
							Spacer()
						}
						hintText(content: "We recommend a photo of yourself because a face helps to build trust")
						Spacer()
					}
					.multilineTextAlignment(.center)
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				case .sign, .name:
					VStack(alignment: .leading, spacing: spacing) {
						hintText(content: "Choose a unique peas sign to make it easy for people to find and remember you")
						HStack {
							Image("SiteLogo")
								.resizable()
								.scaledToFit()
								.frame(dimension: 50)
							textField(hint: "Your Sign", leadingHint: "/", text: $viewModel.sign)
								.font(Font.app.bodySemiBold)
								.focused($focusedField, equals: .sign)
						}
						.padding(.bottom, 40)
						hintText(content: "Feel free to get a little creative with your business name")
						textField(hint: "Business Name", text: $viewModel.name)
							.font(Font.app.bodySemiBold)
							.focused($focusedField, equals: .name)
						Spacer()
					}
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				case .description:
					VStack(alignment: .center, spacing: spacing) {
						HStack {
							Spacer()
						}
						hintText(content: "Tell people about what you do and what services you offer here. Don't sell yourself short ;)")
						descriptionTextField(hint: "Describe your business here", text: $viewModel.description, textLimit: SizeConstants.businessDescriptionLimit)
						Spacer()
					}
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				case .block:
					ScrollView(showsIndicators: false) {
						VStack(alignment: .leading, spacing: 30) {
							HStack {
								let cornerRadius: CGFloat = SizeConstants.blockCornerRadius
								Spacer()
								Button(action: {
									DispatchQueue.main.async {
										self.focusedField = .blockPrice
									}
								}) {
									CachedImage(
										url: viewModel.blockImage,
										content: { uiImage in
											Image(uiImage: uiImage)
												.resizable()
												.scaledToFit()
												.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
												.opacity(0.8)
										},
										placeHolder: {
											ZStack {
												RoundedRectangle(cornerRadius: cornerRadius)
													.fill(Color.app.primaryBackground)
												RoundedRectangle(cornerRadius: cornerRadius)
													.stroke(Color.app.tertiaryText.opacity(0.5), lineWidth: 1)
											}
										}
									)
									.frame(size: CGSize(width: 180, height: 260))
									.overlay {
										Image(systemName: "photo")
											.font(Font.app.largeTitle)
											.foregroundColor(Color.app.tertiaryText)
									}
								}
								.buttonStyle(.plain)
								Spacer()
							}
							.padding(.top, 30)
							blockPricingSection()
							blockTimeSection()
							VStack(alignment: .leading, spacing: 10) {
								hintText(content: "Service")
								textField(hint: "Add a title for your package", hintImage: "text.insert", text: $viewModel.blockTitle)
									.font(Font.app.title2Display)
									.multilineTextAlignment(.center)
								descriptionTextField(hint: "Describe the package", text: $viewModel.blockDescription, textLimit: SizeConstants.descriptionLimit)
								HStack {
									Spacer()
									Button(action: {}) {
										HStack {
											Image(systemName: "trash")
											Text("Delete")
										}
										.font(Font.app.body)
										.padding()
										.background(textBackground())
									}
									Spacer()
								}
								.padding(.top)
							}
							Spacer()
						}
						.padding(.horizontal, horizontalPadding)
					}
				case .links:
					VStack(alignment: .leading, spacing: spacing) {
						hintText(content: "Link your social media accounts below so people can follow you and stay up to date on your journey")
						linkField(image: "X", text: $viewModel.twitter)
						linkField(image: "Instagram", text: $viewModel.instagram)
						linkField(image: "Tiktok", text: $viewModel.tiktok)
						Spacer()
					}
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				case .location:
					VStack {
						HStack {
							Spacer()
							Button(action: {}) {
								HStack {
									Image(systemName: "arrow.clockwise")
									Text("Update")
										.textCase(.uppercase)
								}
								.font(Font.app.caption)
								.foregroundColor(Color.app.primaryText)
								.padding(8)
								.background(
									RoundedRectangle(cornerRadius: SizeConstants.textCornerRadius)
										.stroke(Color.app.tertiaryText)
								)
							}
							.padding(.trailing)
							.padding(.trailing)
						}
						Spacer()
						ZStack(alignment: .bottom) {
							PulseView(size: 200, isActive: true)
							Text(viewModel.location)
								.font(Font.app.title1)
								.foregroundColor(Color.app.primaryText)
								.padding(.bottom, 30)
						}
						Spacer()
					}
					.padding(.top)
					.presentationDetents([.height(400)])
				}
			}
			.background(viewModel.context == .location ? Color.app.primaryBackground : Color.app.secondaryBackground)
			
			if viewModel.context != .location {
				Spacer()
			}
			
			Button(action: {}) {
				Text("Save")
			}
			.buttonStyle(.expanded(style: .black))
			.padding([.horizontal, .bottom])
		}
		.multilineTextAlignment(.leading)
		.tint(Color.app.primaryText)
		.onAppear {
			switch viewModel.context {
			case .sign:
				self.focusedField = .sign
			case .name:
				self.focusedField = .name
			case .description:
				self.focusedField = .description
			case .links:
				self.focusedField = nil
			case .photo, .block, .location:
				return
			}
		}
	}
	
	@ViewBuilder
	func hintText(content: String) -> some View {
		Text(content)
			.font(Font.app.body)
			.foregroundColor(Color.app.tertiaryText)
	}
	
	@ViewBuilder
	func textField(hint: String, hintImage: String? = nil, leadingHint: String? = nil, text: Binding<String>) -> some View {
		HStack {
			if let leadingHint = leadingHint {
				Text("\(leadingHint)")
					.font(Font.app.title2)
					.foregroundColor(Color.app.tertiaryText)
			}
			ZStack(alignment: hintImage == nil ? .leading : .center) {
				textHint(image: hintImage, hint: hint, text: text.wrappedValue)
				TextField("", text: text)
			}
		}
		.foregroundColor(Color.app.primaryText)
		.padding(.horizontal)
		.padding(.vertical, textfieldVerticalPadding)
		.background(textBackground())
	}
	
	@ViewBuilder
	func descriptionTextField(hint: String, text: Binding<String>, textLimit: Int) -> some View {
		ZStack(alignment: .center) {
			textHint(image: "text.viewfinder", hint: hint, text: text.wrappedValue)
			VStack {
				TextField("", text: text.max(textLimit), axis: .vertical)
					.font(.system(size: FontSizes.body, weight: .regular, design: .default))
					.lineLimit(4, reservesSpace: true)
					.focused($focusedField, equals: .description)
				HStack {
					Spacer()
					Text("\(text.wrappedValue.count)/\(textLimit)")
						.foregroundColor(Color.app.tertiaryText)
				}
			}
		}
		.font(Font.app.footnote)
		.padding()
		.background(textBackground())
	}
	
	@ViewBuilder
	func blockPricingSection() -> some View {
		VStack(alignment: .leading, spacing: 6) {
			hintText(content: "Pricing")
			HStack {
				Text("$")
					.foregroundColor(Color.app.tertiaryText)
				PriceTextField(isFocused: $isPriceKeyboardFocused, priceText: $viewModel.blockPriceText)
			}
			.font(Font.app.bodySemiBold)
			.padding(.horizontal)
			.padding(.vertical, textfieldVerticalPadding)
			.background(textBackground())
			.onTapGesture {
				self.isPriceKeyboardFocused.toggle()
			}
		}
	}
	
	@ViewBuilder
	func blockTimeSection() -> some View {
		VStack(alignment: .leading, spacing: 10) {
			hintText(content: "How long will it take you to deliver this service?")
			HStack {
				Text("\(viewModel.blockTimeDuration.timeSpan)")
					.font(Font.app.largeTitle)
					.foregroundColor(Color.app.primaryText)
				Spacer()
				StepperView(min: 0, max: 86400, step: 300, value: $viewModel.blockTimeDuration)
			}
		}
	}
	
	@ViewBuilder
	func linkField(image: String, text: Binding<String>) -> some View {
		HStack(spacing: 20) {
			Image(image)
				.resizable()
				.scaledToFit()
				.frame(dimension: 46)
			textField(hint: "", leadingHint: "@", text: text)
				.font(Font.app.bodySemiBold)
		}
	}
	
	@ViewBuilder
	func textHint(image: String?, hint: String, text: String) -> some View {
		HStack {
			if let image = image {
				Image(systemName: image)
			}
			Text(hint)
		}
		.font(Font.app.callout)
		.foregroundColor(Color.app.tertiaryText)
		.opacity(text.count > 0 ? 0.0 : 1.0)
	}
	
	@ViewBuilder
	func textBackground() -> some View {
		let cornerRadius: CGFloat = SizeConstants.textCornerRadius
		RoundedRectangle(cornerRadius: cornerRadius)
			.fill(Color.white)
		RoundedRectangle(cornerRadius: cornerRadius)
			.stroke(Color.app.tertiaryText.opacity(0.5))
	}
}

struct EditSiteView_Previews: PreviewProvider {
	static var previews: some View {
		EditSiteView(viewModel: .init(business: Business.mock1, context: .photo))
		EditSiteView(viewModel: .init(business: Business.mock1, context: .location))
		EditSiteView(viewModel: .init(business: Business.mock1, context: .links))
		EditSiteView(viewModel: .init( business: Business.mock1, context: .block(Business.mock1.blocks.first!.id)))
	}
}
