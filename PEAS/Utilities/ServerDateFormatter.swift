//
//  ServerDateFormatter.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-19.
//

import Foundation

struct ServerDateFormatter {
	static let dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'"
	static let serverTimeZone: TimeZone = TimeZone(abbreviation: "UTC")!
	
	static func formatToLocal(from serverDate: String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormat
		dateFormatter.timeZone = serverTimeZone
		if let date = dateFormatter.date(from: serverDate) {
			dateFormatter.timeZone = TimeZone.current
			return dateFormatter.string(from: date).toDate()
		}
		return Date()
	}
	
	static func formatToDate(from serverDate: String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormat
		dateFormatter.timeZone = serverTimeZone
		return dateFormatter.date(from: serverDate) ?? Date()
	}
	
	static func formatToUTC(from localDate: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormat
		dateFormatter.timeZone = serverTimeZone
		return dateFormatter.string(from: localDate)
	}
}

struct TimeFormatter {
	static let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = ServerDateFormatter.serverTimeZone
		formatter.dateFormat = "h:mm a"
		return formatter
	}()
	
	static func getTime(date: Date) -> String {
		return timeFormatter.string(from: date)
	}
}

fileprivate extension String {
	func toDate() -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = ServerDateFormatter.dateFormat
		dateFormatter.timeZone = ServerDateFormatter.serverTimeZone
		return dateFormatter.date(from: self) ?? Date()
	}
}
