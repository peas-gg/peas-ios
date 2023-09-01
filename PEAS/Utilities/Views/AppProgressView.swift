//
//  AppProgressView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import SwiftUI

struct AppProgressView: View {
	let isShowing: Bool
	let style: LoadingIndicator.Style
	var body: some View {
		if isShowing {
			Color.black.opacity(0.1).ignoresSafeArea()
				.overlay(
					LoadingIndicator(style: style)
						.frame(dimension: 100)
				)
		}
	}
}

struct AppProgressView_Previews: PreviewProvider {
	static var previews: some View {
		AppProgressView(isShowing: true, style: .black)
		VStack {
			AppProgressView(isShowing: true, style: .green)
		}
	}
}
