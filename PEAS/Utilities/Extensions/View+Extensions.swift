//
//  View+Extensions.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-31.
//

import SwiftUI

struct CGRectPreferenceKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

struct BoundsPreferenceKey: PreferenceKey {
	typealias Value = [Anchor<CGRect>]
	static var defaultValue: Value = []
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value.append(contentsOf: nextValue())
	}
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
	
	func appMenu<Menu: View>(alignment: HorizontalAlignment = .leading, isShowing: Binding<Bool>, @ViewBuilder menu: @escaping () -> Menu) -> some View {
		self.modifier(AppMenuModifier(alignment: alignment, isShowing: isShowing, menu: menu))
	}
	
	func progressView(isShowing: Bool, style: LoadingIndicator.Style, coverOpacity: CGFloat = 0.1) -> some View {
		self
			.overlay {
				AppProgressView(isShowing: isShowing, style: style, coverOpacity: coverOpacity)
			}
	}
	
	func banner(data: Binding<BannerData?>) -> some View {
		self.modifier(BannerViewModifier(data: data))
	}
}
