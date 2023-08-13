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
		VStack {
			Text(formatter.string(from: month))
				.font(Font.app.largeTitle)
				.foregroundColor(Color.app.secondaryText)
			LazyVGrid(columns: Array(repeating: GridItem(), count: weekDays.count)) {
				ForEach(weekDays, id: \.self) { day in
					Text(day)
						.textCase(.uppercase)
						.font(Font.app.bodySemiBold)
						.foregroundColor(Color.app.darkGreen)
				}
				daysPaddingView()
				ForEach(days, id: \.self) { day in
					dayView(dayOfMonth: day.dayOfMonth)
				}
			}
		}
	}
	
	@ViewBuilder
	func dayView(dayOfMonth: Int) -> some View {
		Button(action: {}) {
			RoundedRectangle(cornerRadius: 10)
				.fill(Color.app.darkGreen)
				.frame(dimension: 35)
				.overlay (
					Text("\(dayOfMonth)")
						.font(Font.app.bodySemiBold)
						.foregroundColor(Color.app.secondaryText)
				)
		}
	}
	
	@ViewBuilder
	func daysPaddingView() -> some View {
		let padding = Calendar.current.component(.weekday, from: days.first ?? Date()) - 1
		ForEach(0..<padding, id: \.self) {
			Color.clear
				.id($0)
		}
	}
}

struct MonthView_Previews: PreviewProvider {
	static var previews: some View {
		MonthView(month: Date.now)
			.background(Color.accentColor)
	}
}
