//
//  CardBackground.swift
//  PEAS
//
//  Created by Abdul Bello on 2023-09-14.
//

import SwiftUI

struct CardBackground: View {
	let isAlternate: Bool
	
	init(isAlternate: Bool = false) {
		self.isAlternate = isAlternate
	}
	
	var body: some View {
		ZStack{
			let cornerRadius: CGFloat = 10
			RoundedRectangle(cornerRadius: cornerRadius)
				.fill(isAlternate ? Color.gray.opacity(0.1) : Color.white)
			RoundedRectangle(cornerRadius: cornerRadius)
				.stroke(Color.app.tertiaryText.opacity(0.5))
		}
	}
}

struct CardBackground_Previews: PreviewProvider {
	static var previews: some View {
		CardBackground()
	}
}
