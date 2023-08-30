//
//  AppError.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-18.
//

import Foundation

enum AppError: Error {
	enum APIClientError: Error, Equatable {
		case authExpired
		case invalidURL
		case httpError(statusCode: Int, data: Data)
		case decodingError
		case rawError(String)
		
		var title: String { "API Error" }
	}
	
	case apiClientError(APIClientError)
}
