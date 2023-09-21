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
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
		return dateFormatter
	}()
	
	static func formatToLocal(from serverDate: String) -> Date {
		if let utcDate = utcFormatter.date(from: serverDate) {
			let timeZone = TimeZone.current
			let secondsFromGMT = timeZone.secondsFromGMT(for: utcDate)
			return Date(timeInterval: TimeInterval(secondsFromGMT), since: utcDate)
		}
		return Date()
	}
	
	static func formatToUTC(from localDate: Date) -> String {
		return utcFormatter.string(from: localDate)
	}
}

struct TimeFormatter {
	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		return formatter
	}()
	
	static func getTime(date: Date) -> String {
		return dateFormatter.string(from: date)
	}
}
