//
//  TimeBlock.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2024-01-08.
//

import Foundation

struct TimeBlock: Decodable, Identifiable {
	let id: String
	let title: String
	let startTimeDate: Date
	let endTimeDate: Date
	
	init(_ timeBlockResponse: TimeBlockResponse) {
		self.id = timeBlockResponse.id
		self.title = timeBlockResponse.title
		self.startTimeDate = ServerDateFormatter.formatToDate(from: timeBlockResponse.startTime)
		self.endTimeDate = ServerDateFormatter.formatToDate(from: timeBlockResponse.endTime)
	}
}
