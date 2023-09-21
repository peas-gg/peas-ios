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
	
	var timeOnly: String {
		TimeFormatter.getTime(date: self)
	}
}

extension Date {
	func startOfMonth() -> Date {
		return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
	}
}
