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
	
	let monthFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM yyyy"
		return dateFormatter
	}()
	
	var months: [Date] = []
	
	init() {
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
	
	func getDaysInMonth(_ month: Date) -> [Date] {
		//get the current Calendar for our calculations
		let calendar = Calendar.current
		//get the days in the month as a range, e.g. 1..<32 for March
		let monthRange = calendar.range(of: .day, in: .month, for: month)!
		//get first day of the month
		let components = calendar.dateComponents([.year, .month], from: month)
		//start with the first day
		//building a date from just a year and a month gets us day 1
		var date = calendar.date(from: components)!
		
		//somewhere to store our output
		var dates: [Date] = []
		//loop thru the days of the month
		for _ in monthRange {
			//add to our output array...
			dates.append(date)
			//and increment the day
			date = calendar.date(byAdding: .day, value: 1, to: date)!
		}
		return dates
	}
}
