//
//  DateTimePicker.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-12-29.
//

import SwiftUI

struct DateTimePicker: View {
	enum Context {
		case day
		case time
		case dayAndTime
	}
	
	let context: Context
	
	@Binding var date: Date
	
	var body: some View {
		switch context {
		case .day:
			HStack {
				Image(systemName: "calendar")
					.font(.system(size: FontSizes.title2, weight: .regular, design: .rounded))
					.foregroundStyle(Color.app.tertiaryText)
				Spacer(minLength: 0)
				Text("\(weekDay(style: .wide))")
				Spacer(minLength: 0)
				Text("\(date.dayOfMonth)")
				Spacer(minLength: 0)
				Text("\(month())")
				Spacer(minLength: 0)
				Text("\(year())")
				Spacer(minLength: 0)
				Image(systemName: "chevron.down")
					.foregroundColor(Color.app.tertiaryText)
			}
			.font(Font.app.bodySemiBold)
			.padding()
			.background(CardBackground())
			.overlay(alignment: .center) {
				HStack(spacing: 0) {
					//HACK: We need two dayPickers here to cover enough tappable area
					dayPicker()
					dayPicker()
						.padding(.trailing, 42)
						.offset(x: -10)
				}
			}
		case .time:
			EmptyView()
		case .dayAndTime:
			EmptyView()
		}
	}
	
	@ViewBuilder
	func dayPicker() -> some View {
		DatePicker("", selection: $date, displayedComponents: .date)
			.tint(Color.black)
			.blendMode(.destinationOver)
	}
	
	func weekDay(style: Date.FormatStyle.Symbol.Weekday) -> String {
		return self.date.formatted(Date.FormatStyle().weekday(style))
	}
	
	func month() -> String {
		return self.date.formatted(Date.FormatStyle().month(.abbreviated))
	}
	
	func year() -> String {
		return self.date.formatted(Date.FormatStyle().year(.extended()))
	}
}

#Preview("Day") {
	VStack {
		Spacer()
		DateTimePicker(context: .day, date: Binding.constant(Date()))
			.padding(.horizontal)
		Spacer()
	}
}
