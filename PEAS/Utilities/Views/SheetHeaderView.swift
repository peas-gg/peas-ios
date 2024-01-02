//
//  SheetHeaderView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-12-29.
//

import SwiftUI

struct SheetHeaderView: View {
	let title: String
	var body: some View {
		VStack(spacing: 0) {
			Text("\(title)")
				.font(Font.app.title2)
				.foregroundColor(Color.app.primaryText)
				.padding(.top)
			Divider()
				.padding(.top)
		}
	}
}

#Preview("Sheet Header") {
	SheetHeaderView(title: "Update the time")
}
