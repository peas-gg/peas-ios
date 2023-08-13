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
}
