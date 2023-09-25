//
//  SlidingButtonView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-24.
//

import SwiftUI

struct SlidingButtonView: View {
	let height: CGFloat = 60
	
	@State var xOffset: CGFloat = 6
	
	var body: some View {
		HStack {
			GeometryReader { proxy in
				let width: CGFloat = proxy.frame(in: .local).width
				HStack {
					Circle()
						.fill(Color.red)
						.frame(width: 50, height: 50)
						.offset(x: xOffset)
				}
				.frame(width: width, height: proxy.size.height, alignment: .leading)
				.gesture(
					DragGesture()
						.onChanged { value in
							let xDistance  = value.translation.width
							print("WIDTH: \(width) X: \(xDistance)")
							if (6..<width - 50).contains(xDistance) {
								self.xOffset = value.translation.width
							}
						}
						.onEnded { _ in
							if self.xOffset < (width - 6) {
								self.xOffset = 6
							}
						}
				)
			}
			.frame(height: self.height)
		}
		.background(Color.black, in: Capsule())
		.overlay(Capsule().stroke(Color.black, lineWidth: 2))
	}
}

struct SlidingButtonView_Previews: PreviewProvider {
	static var previews: some View {
		SlidingButtonView()
	}
}
