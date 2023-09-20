//
//  TextBackground.swift
//  PEAS
//
//  Created by Abdul Bello on 2023-09-14.
//

import SwiftUI

struct TextBackground: View {
	var body: some View {
		ZStack{
			let cornerRadius: CGFloat = SizeConstants.textCornerRadius
			RoundedRectangle(cornerRadius: cornerRadius)
				.fill(Color.white)
			RoundedRectangle(cornerRadius: cornerRadius)
				.stroke(Color.app.tertiaryText.opacity(0.5))
		}
	}
}

struct TextBackground_Previews: PreviewProvider {
	static var previews: some View {
		TextBackground()
	}
}