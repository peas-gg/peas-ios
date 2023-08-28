//
//  EditSiteView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-27.
//

import SwiftUI

struct EditSiteView: View {
	@StateObject var viewModel: SiteView.ViewModel
	
	enum Context {
		case sign
		case name
		case description
		case block
		
		var title: String {
			switch self {
			case .sign, .name: return "Peas Sign & Name"
			case .description: return "Description"
			case .block: return "Block"
			}
		}
	}
	
	
	let context: Context
	
	@FocusState private var focusedField: Context?
	
	var body: some View {
		VStack(spacing: 0) {
			Text(context.title)
				.font(Font.app.title2)
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
								.focused($focusedField, equals: .sign)
						}
						.padding(.bottom, 40)
						hintText(content: "Feel free to get a little creative with your business name")
						textField(hint: "Business Name", text: $viewModel.businessName)
							.focused($focusedField, equals: .name)
						Spacer()
					}
				case .description:
					VStack(alignment: .center, spacing: spacing) {
						HStack {
							Spacer()
						}
						hintText(content: "Tell people about what you do and what services you offer here. Don't sell yourself short ;)")
						verticalTextField(hint: "Describe your business here", text: $viewModel.description)
						Spacer()
					}
				case .block:
					VStack(alignment: .center, spacing: spacing) {
						HStack {
							Spacer()
						}
						hintText(content: "Tell people about what you do and what services you offer here. Don't sell yourself short ;)")
						
						Spacer()
					}
				}
			}
			.padding(.top)
			.padding(.horizontal, 25)
			.background(Color.app.secondaryBackground)
		}
		.multilineTextAlignment(.leading)
		.tint(Color.app.primaryText)
		.onAppear {
			self.focusedField = context
		}
	}
	
	@ViewBuilder
	func hintText(content: String) -> some View {
		Text(content)
			.font(Font.app.body)
			.foregroundColor(Color.app.tertiaryText)
	}
	
	@ViewBuilder
	func textField(hint: String, isPeaceSign: Bool = false, text: Binding<String>) -> some View {
		HStack {
			if isPeaceSign {
				Text("/")
					.font(Font.app.title2)
					.foregroundColor(Color.app.tertiaryText)
			}
			ZStack(alignment: .leading) {
				Text(hint)
					.foregroundColor(Color.app.tertiaryText)
					.opacity(text.wrappedValue.isEmpty ? 1.0 : 0.0)
				TextField("", text: text)
					.font(Font.app.bodySemiBold)
			}
		}
		.foregroundColor(Color.app.primaryText)
		.padding(.horizontal)
		.padding(.vertical, 12)
		.background(textBackground())
	}
	
	@ViewBuilder
	func verticalTextField(hint: String, text: Binding<String>) -> some View {
		let textLimit: Int = SizeConstants.textDescriptionLimit
		ZStack(alignment: .center) {
			HStack {
				Image(systemName: "text.viewfinder")
				Text(hint)
			}
			.foregroundColor(Color.app.tertiaryText)
			.opacity(viewModel.description.count > 0 ? 0.0 : 1.0)
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
		EditSiteView(viewModel: .init(isTemplate: true, business: Business.mock1), context: .description)
	}
}
