//
//  ButtonStyles.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-22.
//

import SwiftUI

struct ExpandedButtonStyle: ButtonStyle {
	enum Style {
		case white
		case black
		case green
		case darkGreen
		
		var color: Color {
			switch self {
			case .white: return Color.white
			case .black: return Color.black
			case .green: return Color.app.accent
			case .darkGreen: return Color.app.darkGreen
			}
		}
		
		var foregroundColor: Color {
			switch self {
			case .white: return Color.app.primaryText
			case .black: return Color.app.secondaryText
			case .green: return Color.app.secondaryText
			case .darkGreen: return Color.app.accent
			}
		}
		
		var disabledColor: Color {
			switch self {
			case .white, .black: return Color.gray
			case .green: return Color.app.accent
			case .darkGreen: return Color.app.darkGreen
			}
		}
		
		var disabledForegroundColor: Color {
			switch self {
			case .white: return Color.gray
			case .black: return Color.gray
			case .green: return Color.app.accent
			case .darkGreen: return Color.app.darkGreen
			}
		}
	}
	
	let shouldAnimate: Bool
	let style: Style
	
	@Environment(\.isEnabled) private var isEnabled
	
	init (shouldAnimate: Bool = true, style: ExpandedButtonStyle.Style) {
		self.shouldAnimate = shouldAnimate
		self.style = style
	}
	
	func makeBody(configuration: Configuration) -> some View {
		HStack {
			Spacer()
			configuration.label
				.font(Font.app.title2Display)
				.foregroundColor(isEnabled ? style.foregroundColor : style.disabledForegroundColor)
				.padding(.vertical, 14)
			Spacer()
		}
		.background {
			if isEnabled {
				shape()
					.fill(style.color)
			} else {
				shape()
					.stroke(style.disabledColor, lineWidth: 1)
			}
		}
		.padding(.horizontal)
		.scaleEffect(shouldAnimate && configuration.isPressed ? 0.95 : 1)
		.animation(.easeInOut.speed(2.0), value: shouldAnimate && configuration.isPressed)
	}
	
	private func shape() -> some Shape {
		RoundedRectangle(cornerRadius: 10)
	}
}

extension ButtonStyle where Self == ExpandedButtonStyle {
	static var expanded: Self { ExpandedButtonStyle(style: .black) }
	static func expanded(shouldAnimate: Bool = true, style: ExpandedButtonStyle.Style) -> Self {
		return ExpandedButtonStyle(shouldAnimate: shouldAnimate, style: style)
	}
}

struct ScalingButtonStyle: ButtonStyle {
	enum ScaleDirection {
		case inside
		case outside
	}
	
	let direction: ScaleDirection
	
	@Environment(\.isEnabled) private var isEnabled
	
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? direction == .inside ? 0.88 : 1.12 : 1)
			.animation(.easeInOut.speed(2.0), value: configuration.isPressed)
			.opacity(isEnabled ? 1.0 : 0.5)
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

struct KeypadButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.background {
				RoundedRectangle(cornerRadius: 20)
					.fill(Color.app.darkGreen.opacity(0.2))
					.frame(dimension: 70)
					.opacity(configuration.isPressed ? 1.0 : 0.0)
					.transition(.opacity)
			}
			.animation(.easeOut, value: configuration.isPressed)
	}
}

extension ButtonStyle where Self == KeypadButtonStyle {
	static var keypad: Self { KeypadButtonStyle() }
}
