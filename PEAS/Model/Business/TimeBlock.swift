//
//  TimeBlock.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2024-01-08.
//

import Foundation

struct TimeBlock: Codable, Identifiable, Hashable {
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

extension TimeBlock {
	static var mock1: Self {
		return TimeBlock(
			TimeBlockResponse(
				id: UUID().uuidString,
				title: "Vacation with the girls 🛫🏖️",
				startTime: "2024-01-08T07:10:00Z",
				endTime: "2024-01-10T07:10:00Z"
			)
		)
	}
}
