//
//  ShimmerTextView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-25.
//

import SwiftUI

struct ShimmerTextView: View {
	let text: String
	let font: Font
	let foregroundColor: Color
	
	@State var width: CGFloat = .zero
	@State var xOffset: CGFloat = .zero
	
	init(_ text: String, font: Font = Font.app.largeTitle, foregroundColor: Color = Color.gray) {
		self.text = text
		self.font = font
		self.foregroundColor = foregroundColor
	}
	
	var body: some View {
		ZStack {
			Text(text)
				.font(font)
				.foregroundColor(foregroundColor)
				.readRect { rect in
					self.width = rect.width
				}
			HStack(spacing: 0) {
				ForEach(0..<text.count, id: \.self) { index in
					Text(String(text[text.index(text.startIndex, offsetBy: index)]))
						.font(font)
						.foregroundStyle(
							LinearGradient(
								colors: [Color.white, Color.white.opacity(0.6)],
								startPoint: .leading,
								endPoint: .trailing
							)
						)
				}
			}
			.mask {
				Rectangle()
					.rotationEffect(.degrees(-100))
					.offset(x: -100)
					.offset(x: xOffset)
			}
		}
		.animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: xOffset)
		.onAppear {
			self.xOffset = 200
		}
	}
}

struct ShimmerTextView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Spacer()
			ShimmerTextView("Slide to Cancel")
			Spacer()
		}
		.preferredColorScheme(.dark)
	}
}
