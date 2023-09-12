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
	typealias Value = [String : Anchor<CGRect>]
	static var defaultValue: Value = [:]
	static func reduce(value: inout Value, nextValue: () -> [String : Anchor<CGRect>]) {
		if let key = nextValue().keys.first, let anchor = nextValue().values.first {
			if !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
				value.updateValue(anchor, forKey: key)
			}
		}
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
	
	func appMenu<Menu: View>(id: String, isShowing: Binding<Bool>, @ViewBuilder menu: @escaping () -> Menu) -> some View {
		self.modifier(AppMenuModifier(id: id, isShowing: isShowing, menu: menu))
	}
	
	func fullScreenContainer<Content: View>(
		isShowing: Binding<Bool>,
		@ViewBuilder _ content: @escaping () -> Content
	) -> some View {
		overlay {
			FullScreenContainer(isShowing: isShowing) {
				content()
			}
		}
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
