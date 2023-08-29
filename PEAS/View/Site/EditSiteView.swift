//
//  EditSiteView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-27.
//

import SwiftUI

struct EditSiteView: View {
	@StateObject var viewModel: SiteView.ViewModel
	
	enum FocusField: Hashable {
		case sign
		case name
		case description
		case blockPrice
	}
	
	enum Context {
		case sign
		case name
		case description
		case block(_ blockId: Business.Block.ID)
		
		var title: String {
			switch self {
			case .sign, .name: return "Peas Sign & Name"
			case .description: return "Description"
			case .block: return "Block"
			}
		}
	}
	
	let context: Context
	let textfieldVerticalPadding: CGFloat = 12
	
	@FocusState private var focusedField: FocusField?
	
	@State private var blockPriceText: String = ""
	@State private var blockTimeDuration: Int = 0
	@State private var blockTitle: String = ""
	@State private var blockDescription: String = ""
	
	@State private var isPriceKeyboardFocused: Bool = false
	
	var body: some View {
		VStack(spacing: 0) {
			let horizontalPadding: CGFloat = 25
			Text(context.title)
				.font(Font.app.title2)
				.foregroundColor(Color.app.primaryText)
				.padding(.top)
			Divider()
				.padding(.top)
			VStack {
				let spacing: CGFloat = 20
				switch context {
				case .sign, .name:
					VStack(alignment: .leading, spacing: spacing) {
						hintText(content: "Choose a unique peas sign to make it easy for people to find you")
						HStack {
							Image("SiteLogo")
								.resizable()
								.scaledToFit()
								.frame(dimension: 50)
							textField(hint: "Your Sign", isPeaceSign: true, text: $viewModel.peasSign)
								.font(Font.app.bodySemiBold)
								.focused($focusedField, equals: .sign)
						}
						.padding(.bottom, 40)
						hintText(content: "Feel free to get a little creative with your business name")
						textField(hint: "Business Name", text: $viewModel.businessName)
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
						descriptionTextField(hint: "Describe your business here", text: $viewModel.description)
						Spacer()
					}
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				case .block(let blockId):
					if let block: Business.Block = viewModel.business.blocks[id: blockId] {
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
											url: block.image,
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
									textField(hint: "Add a title for your package", hintImage: "text.insert", text: $blockTitle)
										.font(Font.app.title2Display)
										.multilineTextAlignment(.center)
									descriptionTextField(hint: "Describe the package", text: $blockDescription)
								}
								Spacer()
							}
							.padding(.horizontal, horizontalPadding)
						}
					}
				}
			}
			.background(Color.app.secondaryBackground)
		}
		.multilineTextAlignment(.leading)
		.tint(Color.app.primaryText)
		.onAppear {
			switch context {
			case .sign:
				self.focusedField = .sign
			case .name:
				self.focusedField = .name
			case .description:
				self.focusedField = .description
			case .block(let id):
				self.focusedField = nil
				self.blockPriceText = viewModel.business.blocks[id: id]?.price.priceToText ?? ""
				self.blockTimeDuration = viewModel.business.blocks[id: id]?.duration ?? 0
				self.blockTitle = viewModel.business.blocks[id: id]?.title ?? ""
				self.blockDescription = viewModel.business.blocks[id: id]?.description ?? ""
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
	func textField(hint: String, hintImage: String? = nil, isPeaceSign: Bool = false, text: Binding<String>) -> some View {
		HStack {
			if isPeaceSign {
				Text("/")
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
	func descriptionTextField(hint: String, text: Binding<String>) -> some View {
		let textLimit: Int = SizeConstants.textDescriptionLimit
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
				PriceTextField(isFocused: $isPriceKeyboardFocused, priceText: $blockPriceText)
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
				Text("\(blockTimeDuration.timeSpan)")
					.font(Font.app.largeTitle)
					.foregroundColor(Color.app.primaryText)
				Spacer()
				StepperView(min: 0, max: 86400, step: 300, value: $blockTimeDuration)
			}
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
		EditSiteView(viewModel: .init(isTemplate: true, business: Business.mock1), context: .block(Business.mock1.blocks.first!.id))
	}
}
