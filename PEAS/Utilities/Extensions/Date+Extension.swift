//
//  Date+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-12.
//

import Foundation

extension Date {
	init(year: Int) {
		let dateComponents = DateComponents(calendar: .current, year: year)
		self = Calendar.current.date(from: dateComponents) ?? Date()
	}
}

extension Date {
	var dayOfMonth: Int {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.day], from: self)
		return components.day ?? -1
	}
	
	var serverTimeOnly: String {
		TimeFormatter.getServerTime(date: self)
	}
	
	var localTimeOnly: String {
		TimeFormatter.getLocalTime(date: self)
	}
}

extension Date {
	func startOfMonth() -> Date {
		return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
	}
	
	func timeAgoDisplay() -> String {
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .short
		return formatter.localizedString(for: self, relativeTo: Date())
	}
	
	func isBetween(_ date1: Date, and date2: Date) -> Bool {
		return (min(date1, date2) ... max(date1, date2)).contains(self)
	}
	
	func getTimeSpan(from: Date) -> Int {
		return Int(self.timeIntervalSince(from))
	}
}
