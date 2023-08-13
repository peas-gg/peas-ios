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
	
	let dateNow: Date = Calendar.current.startOfDay(for: Date.now)
	
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
				daysOffsetView()
				ForEach(days, id: \.self) { day in
					dayView(date: day)
				}
			}
			.padding(.horizontal)
		}
	}
	
	@ViewBuilder
	func dayView(date: Date) -> some View {
		let foregroundColor: Color = Color.app.secondaryText
		Button(action: {}) {
			ZStack {
				let cornerRadius: CGFloat = 10
				if Calendar.current.isDateInToday(date) {
					RoundedRectangle(cornerRadius: cornerRadius)
						.stroke(Color.app.darkGreen, lineWidth: 2)
				} else {
					RoundedRectangle(cornerRadius: cornerRadius)
						.fill(Color.clear)
				}
			}
			.frame(dimension: 35)
			.overlay (
				Text("\(date.dayOfMonth)")
					.strikethrough(date < dateNow, color: foregroundColor)
					.font(Font.app.bodySemiBold)
					.foregroundColor(foregroundColor)
			)
		}
	}
	
	@ViewBuilder
	func daysOffsetView() -> some View {
		let offset = Calendar.current.component(.weekday, from: days.first ?? Date()) - 1
		ForEach(0..<offset, id: \.self) {
			Color.clear
				.id($0)
		}
	}
}

struct MonthView_Previews: PreviewProvider {
	static var previews: some View {
		MonthView(month: Date.now)
			.background(Color.app.accent)
	}
}
