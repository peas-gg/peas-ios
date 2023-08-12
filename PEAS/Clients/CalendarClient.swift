//
//  CalendarClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-12.
//

import Foundation

class CalendarClient {
	static let shared: CalendarClient = CalendarClient()
	
	let startDate: Date = Date(year: 2023)
	let endDate: Date =  Calendar.current.date(byAdding: .year, value: 2, to: Date()) ?? Date()
}
