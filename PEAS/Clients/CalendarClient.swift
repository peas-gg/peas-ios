//
//  CalendarClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-12.
//

import Foundation

class CalendarClient {
	static let shared: CalendarClient = CalendarClient()
	
	let startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date(year: 2023)) ?? Date()
	let endDate: Date = Calendar.current.date(byAdding: .year, value: 2, to: Date()) ?? Date()
	
	let monthFormatter: DateFormatter
	
	let weekDays: [String]
	
	var months: [Date] = []
	
	init() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM yyyy"
		
		self.monthFormatter = dateFormatter
		self.weekDays = dateFormatter.shortWeekdaySymbols ?? []
		
		Calendar.current.enumerateDates(startingAfter: startDate, matching: DateComponents(weekOfMonth: 1), matchingPolicy: .nextTime) { date, _, stop in
			if let date = date {
				if date <= endDate {
					months.append(date)
				} else {
					stop = true
				}
			}
		}
	}
	
	func getDaysInWeek(_ day: Date) -> [Date] {
		let firstDayOfTheWeek: Int = 1
		var calendar = Calendar.current
		calendar.firstWeekday = firstDayOfTheWeek
		let date = calendar.startOfDay(for: day)
		
		var week = [Date]()
		if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) {
			for i in 0...weekDays.count - firstDayOfTheWeek {
				if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
					if Calendar.current.isDate(day, equalTo: date, toGranularity: .month) {
						week += [day]
					}
				}
			}
		}
		return week
	}
	
	func getDaysInMonth(_ month: Date) -> [Date] {
		//get the current Calendar for our calculations
		let calendar = Calendar.current
		//get the days in the month as a range, e.g. 1..<32 for March
		let monthRange = calendar.range(of: .day, in: .month, for: month) ?? 0..<1
		//get first day of the month
		let components = calendar.dateComponents([.year, .month], from: month)
		//start with the first day
		//building a date from just a year and a month gets us day 1
		var date = calendar.date(from: components) ?? Date()
		
		//somewhere to store our output
		var dates: [Date] = []
		//loop thru the days of the month
		for _ in monthRange {
			//add to our output array...
			dates.append(date)
			//and increment the day
			date = calendar.date(byAdding: .day, value: 1, to: date) ?? Date()
		}
		return dates
	}
}
