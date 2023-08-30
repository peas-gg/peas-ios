//
//  CachedAvatar.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-25.
//

import SwiftUI

struct CachedAvatar: View {
	let url: URL
	let height: CGFloat
	let width: CGFloat
	
	let rectangleWidth: CGFloat
	let rectangleHeight: CGFloat
	
	init(url: URL, height: CGFloat) {
		let rectangleScale: CGFloat = 1.10
		let width: CGFloat = 0.833 * height
		
		self.url = url
		self.height = height
		self.width = width
		self.rectangleWidth = width * rectangleScale
		self.rectangleHeight = height * rectangleScale
	}
	
	var body: some View {
		RoundedRectangle(cornerRadius: rectangleWidth)
			.fill(Color.white)
			.frame(width: rectangleWidth, height: rectangleHeight)
			.cornerRadius(rectangleWidth)
			.overlay(
				CachedImage(
					url: url,
					content: { uiImage in
						Image(uiImage: uiImage)
							.resizable()
							.scaledToFill()
					},
					placeHolder: {
						Color.gray
					}
				)
				.frame(width: width, height: height)
				.cornerRadius(width)
			)
	}
}

struct CachedAvatar_Previews: PreviewProvider {
	static var previews: some View {
		CachedAvatar(
			url: URL(string: "https://kingsleyokeke.blob.core.windows.net/images/1597276037537.jpeg")!,
			height: 60
		)
		.preferredColorScheme(.dark)
	}
}
