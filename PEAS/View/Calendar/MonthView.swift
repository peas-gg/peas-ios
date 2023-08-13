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
	
	let isCollapsed: Bool
	let selectedDate: Date?
	
	init(month: Date, selectedDate: Date? = nil, isCollapsed: Bool = false) {
		self.month = month
		self.days = CalendarClient.shared.getDaysInMonth(month)
		self.weekDays = CalendarClient.shared.weekDays
		self.isCollapsed = isCollapsed
		self.selectedDate = {
			if let selectedDate = selectedDate {
				return Calendar.current.startOfDay(for: selectedDate)
			}
			return nil
		}()
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
				if let selectedDate = selectedDate, isCollapsed {
					let dates: [Date] = CalendarClient.shared.getDaysInWeek(selectedDate)
					let offSet: Int = weekDays.count - dates.count
					weekOffsetForSelectedDate(offset: offSet)
					ForEach(dates, id: \.self) { day in
						dayView(date: day)
					}
				} else {
					daysOffsetView()
					ForEach(days, id: \.self) { day in
						dayView(date: day)
					}
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
				let isDateSelected: Bool = selectedDate == date
				
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(Color.clear)
				
				if Calendar.current.isDateInToday(date) {
					RoundedRectangle(cornerRadius: cornerRadius)
						.stroke(Color.app.darkGreen, lineWidth: 2)
				}
				
				if isDateSelected {
					RoundedRectangle(cornerRadius: cornerRadius)
						.fill(Color.app.darkGreen)
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
	
	@ViewBuilder
	func weekOffsetForSelectedDate(offset: Int) -> some View {
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
		MonthView(
			month: Date.now,
			selectedDate: Calendar.current.date(byAdding: .init(day: 2), to: Date.now),
			isCollapsed: true
		)
		.background(Color.app.accent)
	}
}
