//
//  ServerDateFormatter.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-19.
//

import Foundation

struct ServerDateFormatter {
	static let utcFormatter = {
		let dateFormatter = ISO8601DateFormatter()
		dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
		return dateFormatter
	}()
	
	static let localFormatter = {
		let dateFormatter = ISO8601DateFormatter()
		dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		dateFormatter.timeZone = TimeZone.current
		return dateFormatter
	}()
	
	static func formatToLocal(from serverDate: String) -> Date {
		if let utcDate = utcFormatter.date(from: serverDate) {
			let localDateString = localFormatter.string(from: utcDate)
			return localFormatter.date(from: localDateString) ?? Date()
		}
		return Date()
	}
	
	static func formatToUTC(from localDate: Date) -> String {
		return utcFormatter.string(from: localDate)
	}
}

struct TimeFormatter {
	static let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		return formatter
	}()
	
	static func getTime(date: Date) -> String {
		return timeFormatter.string(from: date)
	}
}
