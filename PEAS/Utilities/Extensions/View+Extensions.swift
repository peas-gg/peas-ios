//
//  View+Extensions.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-31.
//

import SwiftUI

private struct CGRectPreferenceKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

extension View {
	func readRect(onChange: @escaping (CGRect) -> Void) -> some View {
		background(
			GeometryReader { geometryProxy in
				Color.clear
					.preference(key: CGRectPreferenceKey.self, value: geometryProxy.frame(in: .global))
			}
		)
		.onPreferenceChange(CGRectPreferenceKey.self, perform: onChange)
	}
	
	func menu<Content: View>(isShowing: Binding<Bool>, parentRect: CGRect, topPadding: CGFloat = 0.0, @ViewBuilder content: @escaping () -> Content) -> some View {
		self.modifier(MenuViewModifier(parentRect: parentRect, topPadding: topPadding, isShowing: isShowing, menu: content))
	}
	
	func progressView(isShowing: Bool, style: LoadingIndicator.Style) -> some View {
		self
			.overlay {
				AppProgressView(isShowing: isShowing, style: style)
			}
	}
}
