//
//  CardBackground.swift
//  PEAS
//
//  Created by Abdul Bello on 2023-09-14.
//

import SwiftUI

struct CardBackground: View {
	enum Style {
		case white
		case lightGray
		case black
		
		var backgroundColor: Color {
			switch self {
			case .white: return Color.white
			case .lightGray: return Color.gray.opacity(0.1)
			case .black: return Color.black
			}
		}
	}
	
	let style: Style
	
	init(style: Style = .white) {
		self.style = style
	}
	
	var body: some View {
		ZStack{
			let cornerRadius: CGFloat = 10
			RoundedRectangle(cornerRadius: cornerRadius)
				.fill(style.backgroundColor)
			RoundedRectangle(cornerRadius: cornerRadius)
				.stroke(Color.app.tertiaryText.opacity(0.5))
		}
	}
}

struct CardBackground_Previews: PreviewProvider {
	static var previews: some View {
		CardBackground(style: .white)
	}
}
