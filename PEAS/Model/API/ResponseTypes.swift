//
//  ResponseTypes.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-18.
//

import Foundation

struct SuccessResponse: Codable {
	let success: Bool
}

struct EmptyResponse: Codable {
	
}

struct ErrorResponse: Codable {
	let message: String
}
