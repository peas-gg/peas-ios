//
//  View+Overlay.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-12.
//

import SwiftUI

extension View {
	func overlay<Content: View>(
		isShown: Bool,
		alignment: Alignment = .center,
		@ViewBuilder _ content: @escaping () -> Content
	) -> some View {
		overlay(alignment: alignment) {
			if isShown { content() }
		}
	}
}
