//
//  Int+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-27.
//

import Foundation

extension Int {
	var timeSpan: String {
		let hour: Int = self / 3600
		let minute: Int = (self / 60) % 60
		let hourDescription = hour > 1 ? "hrs" : "hr"
		let minuteDescription = minute > 1 ? "mins" : "min"
		var result: String = ""
		
		if hour > 0 {
			result += "\(hour) \(hourDescription)"
		}
		
		if hour > 0 && minute > 0 {
			result += ", \(minute) \(minuteDescription)"
		}
		
		if hour <= 0 && minute >= 0 {
			result += "\(minute) \(minuteDescription)"
		}
		
		return result
	}
}
