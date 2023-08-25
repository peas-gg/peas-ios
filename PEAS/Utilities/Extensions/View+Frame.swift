//
//  View+Frame.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-12.
//

import SwiftUI

extension View {
	func frame(dimension: CGFloat?, alignment: Alignment = .center) -> some View {
		frame(width: dimension, height: dimension, alignment: alignment)
	}
	
	func frame(size: CGSize, alignment: Alignment = .center) -> some View {
		frame(width: size.width, height: size.height, alignment: alignment)
	}
	
	func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
	}
}
