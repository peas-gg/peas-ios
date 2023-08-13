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
}
