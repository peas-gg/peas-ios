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
		case name
		
		var title: String {
			switch self {
			case .name: return "Peas Sign & Name"
			}
		}
	}
	
	let context: Context
	
	var body: some View {
		VStack(spacing: 0) {
			Text(context.title)
				.font(Font.app.title2)
			Divider()
				.padding(.top)
			VStack {
				switch context {
				case .name:
					VStack(alignment: .leading, spacing: 30) {
						hintText(content: "Choose a unique peas sign to make it easy for people to find you")
						HStack {
							Image("SiteLogo")
								.resizable()
								.scaledToFit()
								.frame(dimension: 50)
							textField(hint: "Your Sign", isPeaceSign: true, text: $viewModel.peasSign)
						}
						hintText(content: "Feel free to get a little creative with your business name")
						textField(hint: "Business Name", text: $viewModel.businessName)
						Spacer()
					}
					.padding(.top)
				}
			}
			.background(Color.app.secondaryBackground)
		}
		.multilineTextAlignment(.leading)
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
		.tint(Color.app.primaryText)
		.padding(.horizontal)
		.padding(.vertical, 12)
		.background {
			let cornerRadius: CGFloat = 10
			RoundedRectangle(cornerRadius: cornerRadius)
				.fill(Color.white)
			RoundedRectangle(cornerRadius: cornerRadius)
				.stroke(Color.app.tertiaryText.opacity(0.5))
		}
	}
}

struct EditSiteView_Previews: PreviewProvider {
	static var previews: some View {
		EditSiteView(viewModel: .init(isTemplate: true, business: Business.mock1), context: .name)
	}
}
