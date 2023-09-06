//
//  Font+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

extension Font {
	enum app {}
	
	static func system(_ style: Font.TextStyle, design: Design = .default, weight: Weight) -> Font {
		.system(style, design: design).weight(weight)
	}
}

struct FontSizes {
	static let caption: CGFloat = 11
	static let footnote: CGFloat = 12
	static let callout: CGFloat = 13
	static let body: CGFloat = 15
	static let title3: CGFloat = 18
	static let title2: CGFloat = 20
	static let title1: CGFloat = 25
	static let largeTitle: CGFloat = 30
}

extension Font.app {
	static var caption: Font { .system(size: FontSizes.caption, weight: .regular, design: .rounded) }
	static var captionSemiBold: Font { .system(size: FontSizes.caption, weight: .semibold, design: .rounded) }
	static var footnote: Font { .system(size: FontSizes.footnote, weight: .regular, design: .rounded) }
	static var callout: Font { .system(size: FontSizes.callout, weight: .regular, design: .rounded) }
	static var body: Font { .system(size: FontSizes.body, weight: .regular, design: .rounded) }
	static var bodySemiBold: Font { .system(size: FontSizes.body, weight: .semibold, design: .rounded) }
	static var subHeader: Font { .system(size: FontSizes.title3, weight: .regular, design: .rounded) }
	static var title3: Font { .system(size: FontSizes.title3, weight: .medium, design: .rounded) }
	static var title2: Font { .system(size: FontSizes.title2, weight: .semibold, design: .rounded) }
	static var title2Display: Font { .system(size: FontSizes.title2, weight: .semibold, design: .default) }
	static var title1: Font { .system(size: FontSizes.title1, weight: .medium, design: .rounded) }
	static var largeTitle: Font { .system(size: FontSizes.largeTitle, weight: .semibold, design: .rounded) }
}
