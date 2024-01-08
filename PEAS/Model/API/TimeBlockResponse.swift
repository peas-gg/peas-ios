//
//  TimeBlockResponse.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2024-01-08.
//

import Foundation

struct TimeBlockResponse: Decodable {
	let id: String
	let title: String
	let startTime: String
	let endTime: String
}

struct CreateTimeBlock: Encodable {
	let title: String
	let startTime: String
	let endTime: String
}
