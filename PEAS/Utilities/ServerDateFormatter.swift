//
//  ServerDateFormatter.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-19.
//

import Foundation

class ServerDateFormatter {
	static let shared: ServerDateFormatter = ServerDateFormatter()
	static let dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'"
	static let serverTimeZone: TimeZone = TimeZone(abbreviation: "UTC")!
	
	static let serverDateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormat
		dateFormatter.timeZone = serverTimeZone
		return dateFormatter
	}()
	
	static let localDateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormat
		dateFormatter.timeZone = TimeZone.current
		return dateFormatter
	}()
	
	static func formatToLocal(from serverDate: String) -> Date {
		if let date = serverDateFormatter.date(from: serverDate) {
			return serverDateFormatter.date(from: localDateFormatter.string(from: date)) ?? Date()
		}
		return Date()
	}
	
	static func formatToDate(from serverDate: String) -> Date {
		return serverDateFormatter.date(from: serverDate) ?? Date()
	}
	
	static func formatToUTC(from localDate: Date) -> String {
		return serverDateFormatter.string(from: localDate)
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
