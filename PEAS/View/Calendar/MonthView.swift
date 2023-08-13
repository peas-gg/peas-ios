//
//  MonthView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-12.
//

import SwiftUI

struct MonthView: View {
	let date: Date
	let formatter: DateFormatter = CalendarClient.shared.monthFormatter
	
	var body: some View {
		Text(formatter.string(from: date))
			.font(Font.app.largeTitle)
			.foregroundColor(Color.app.secondaryText)
	}
}

struct MonthView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			MonthView(date: Date.now)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.accentColor)
	}
}
