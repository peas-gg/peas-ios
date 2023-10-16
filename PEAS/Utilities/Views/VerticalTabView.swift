//
//  VerticalTabView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-12.
//

//SOURCE: https://github.com/lorenzofiamingo/swiftui-vertical-tab-view

import SwiftUI

struct VerticalTabView<Content>: View where Content: View {
	var indexPosition: IndexPosition
	var hasOffset: Bool
	
	var content: () -> Content
	
	@Binding var selectionValue: Int
	
	@State var selection: Int
	
	/// Creates an instance that selects from content associated with
	/// `Selection` values.
	init(selectionValue: Binding<Int>, indexPosition: IndexPosition = .leading, hasOffset: Bool, @ViewBuilder content: @escaping () -> Content) {
		self._selection = State(initialValue: selectionValue.wrappedValue)
		self._selectionValue = selectionValue
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
			TabView(selection: $selection) {
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
		.onChange(of: self.selectionValue) { newValue in
			self.selection = newValue
		}
		.onChange(of: hasOffset) { _ in
			self.selection = selectionValue
		}
	}
	
	enum IndexPosition {
		case leading
		case trailing
	}
}

extension VerticalTabView {
	init(indexPosition: IndexPosition = .leading, hasOffset: Bool, @ViewBuilder content: @escaping () -> Content) {
		self._selection = State(initialValue: 0)
		self._selectionValue = Binding.constant(0)
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
