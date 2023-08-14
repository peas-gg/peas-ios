//
//  VerticalTabView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-12.
//

//SOURCE: https://github.com/lorenzofiamingo/swiftui-vertical-tab-view

import SwiftUI

struct VerticalTabView<Content, SelectionValue>: View where Content: View, SelectionValue: Hashable {
	
	var selection: Binding<SelectionValue>?
	
	var indexPosition: IndexPosition
	var hasOffset: Bool
	
	var content: () -> Content
	
	/// Creates an instance that selects from content associated with
	/// `Selection` values.
	init(selection: Binding<SelectionValue>?, indexPosition: IndexPosition = .leading, hasOffset: Bool, @ViewBuilder content: @escaping () -> Content) {
		self.selection = selection
		self.indexPosition = indexPosition
		self.hasOffset = hasOffset
		self.content = content
	}
	
	var flippingAngle: Angle {
		switch indexPosition {
		case .leading:
			return .degrees(0)
		case .trailing:
			return .degrees(180)
		}
	}
	
	var body: some View {
		GeometryReader { proxy in
			TabView(selection: selection) {
				Group {
					content()
				}
				.frame(width: proxy.size.width, height: proxy.size.height)
				.rotationEffect(.degrees(-90))
				.rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0))
			}
			.frame(width: proxy.size.height, height: proxy.size.width)
			.rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0))
			.rotationEffect(.degrees(90), anchor: .topLeading)
			.offset(x: proxy.size.width + (hasOffset ? 22 : 0))
			/**
			 I wish I could explain why I need the arbitrary 22 value above.
			 But somehow, when a y offset is added to this view for animation purposes, it behave really weird where the xOffset is displaced.
			 */
		}
	}
	
	enum IndexPosition {
		case leading
		case trailing
	}
}

extension VerticalTabView where SelectionValue == Int {
	init(indexPosition: IndexPosition = .leading, hasOffset: Bool, @ViewBuilder content: @escaping () -> Content) {
		self.selection = nil
		self.indexPosition = indexPosition
		self.hasOffset = hasOffset
		self.content = content
	}
}

struct VerticalTabView_Previews: PreviewProvider {
	static var previews: some View {
		VerticalTabView(hasOffset: false) {
			ForEach(0..<20) {
				Text("Number: \($0)")
			}
		}
		.tabViewStyle(.page)
	}
}
