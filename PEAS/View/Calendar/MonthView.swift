//
//  MonthView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-12.
//

import SwiftUI

struct MonthView: View {
	let month: Date
	let days: [Date]
	let weekDays: [String]
	
	let formatter: DateFormatter = CalendarClient.shared.monthFormatter
	
	init(month: Date) {
		self.month = month
		self.days = CalendarClient.shared.getDaysInMonth(month)
		self.weekDays = CalendarClient.shared.monthFormatter.shortWeekdaySymbols ?? []
	}
	
	var body: some View {
		VStack(spacing: 20) {
			Text(formatter.string(from: month))
				.font(Font.app.largeTitle)
				.foregroundColor(Color.app.secondaryText)
			HStack {
				ForEach(weekDays, id: \.self) { day in
					Spacer()
					Text(day)
						.textCase(.uppercase)
						.font(Font.app.semiBoldBody)
						.foregroundColor(Color.app.darkGreen)
					Spacer()
				}
			}
		}
	}
}

struct MonthView_Previews: PreviewProvider {
	static var previews: some View {
		MonthView(month: Date.now)
			.background(Color.accentColor)
	}
}
