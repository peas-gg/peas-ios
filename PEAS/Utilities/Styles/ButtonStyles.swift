//
//  ButtonStyles.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-22.
//

import SwiftUI

struct ExpandedButtonStyle: ButtonStyle {
	
	let shouldAnimate: Bool
	let invertedStyle: Bool
	
	@Environment(\.isEnabled) private var isEnabled
	
	init (shouldAnimate: Bool = true, invertedStyle: Bool = false) {
		self.shouldAnimate = shouldAnimate
		self.invertedStyle = invertedStyle
	}
	
	func makeBody(configuration: Configuration) -> some View {
		let foregroundColor: Color = {
			if self.isEnabled {
				return self.invertedStyle ? Color.black : Color.app.tertiaryText
			} else {
				return .gray
			}
		}()
		
		HStack {
			Spacer()
			configuration.label
				.font(Font.app.title3)
				.textCase(.uppercase)
				.foregroundColor(foregroundColor)
				.padding()
			Spacer()
		}
		.background {
			if invertedStyle {
				invertedButtonStyleView()
			} else {
				if isEnabled {
					shape()
						.fill(Color.app.accent)
				} else {
					invertedButtonStyleView()
				}
			}
		}
		.padding(.horizontal)
		.scaleEffect(shouldAnimate && configuration.isPressed ? 0.95 : 1)
		.animation(.easeInOut.speed(2.0), value: shouldAnimate && configuration.isPressed)
	}
	
	private func shape() -> some Shape {
		RoundedRectangle(cornerRadius: 10)
	}
	
	private func invertedButtonStyleView() -> some View {
		shape()
			.fill(Color.black)
			.overlay(
				shape()
					.stroke(lineWidth: 1)
					.fill(isEnabled ? Color.app.accent : Color.gray)
			)
	}
}

extension ButtonStyle where Self == ExpandedButtonStyle {
	static var expanded: Self { ExpandedButtonStyle() }
	static func expanded(shouldAnimate: Bool = true, invertedStyle: Bool) -> Self {
		return ExpandedButtonStyle(shouldAnimate: shouldAnimate, invertedStyle: invertedStyle)
	}
}

struct ScalingButtonStyle: ButtonStyle {
	enum ScaleDirection {
		case inside
		case outside
	}
	
	let direction: ScaleDirection
	
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? direction == .inside ? 0.88 : 1.04 : 1)
			.animation(.easeInOut.speed(2.0), value: configuration.isPressed)
	}
}

extension ButtonStyle where Self == ScalingButtonStyle {
	static var insideScaling: Self { ScalingButtonStyle(direction: .inside) }
	static var outsideScaling: Self { ScalingButtonStyle(direction: .outside) }
}

struct BrightButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.brightness(configuration.isPressed ? 0.2 : 0.0)
			.animation(.easeInOut, value: configuration.isPressed)
	}
}

extension ButtonStyle where Self == BrightButtonStyle {
	static var bright: Self { BrightButtonStyle() }
}
