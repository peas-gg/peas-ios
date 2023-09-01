//
//  LoadingIndicator.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import SwiftUI

struct LoadingIndicator: View {
	enum Style {
		case white
		case black
		case green
	}
	
	var speed: CGFloat = 0.3
	var style: Style = .white
	var lineWidth: CGFloat = 10.0
	var trim: CGFloat = 0.4
	
	@State var isAnimating: Bool = false
	
	var body: some View {
		let colors: [Color] = {
			switch style {
			case .white:
				return [Color.white, Color.gray.opacity(0.4)]
			case.black:
				return [Color.black, Color.black.opacity(0.4)]
			case .green:
				return [Color.app.accent, Color.app.accent.opacity(0.4)]
			}
		}()
		Circle()
			.trim(from: 0, to: trim)
			.stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
			.fill(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
			.rotationEffect(isAnimating ? .degrees(360): .degrees(0))
			.animation(.linear.speed(speed).repeatForever(autoreverses: false), value: self.isAnimating)
			.onAppear {
				self.isAnimating = true
			}
	}
}

struct LoadingIndicator_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			LoadingIndicator(style: .white)
				.frame(dimension: 40)
		}
		.pushOutFrame()
		.background(Color.black)
		VStack {
			LoadingIndicator(style: .black)
				.frame(dimension: 60)
		}
		.pushOutFrame()
		.background(Color.white)
		VStack {
			LoadingIndicator(style: .green)
				.frame(dimension: 100)
		}
		.pushOutFrame()
		.background(Color.white)
	}
}
