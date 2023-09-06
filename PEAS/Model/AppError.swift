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

extension AppError.APIClientError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .authExpired:
			return NSLocalizedString(
				"Authentication Token expired",
				comment: "Auth Expired"
			)
			case .invalidURL:
				return NSLocalizedString(
					"Request URL could not be formed or is Invalid",
					comment: "Invalid Url"
				)
			case let .httpError(statusCode: _, data: data):
				return NSLocalizedString(
					"\(String(decoding: data, as: UTF8.self))",
					comment: "HTTP Error"
				)
			case .decodingError:
				return NSLocalizedString(
					"Error Decoding Object: Please try that again",
					comment: "Decoder Error"
				)
			case .rawError(let error):
				return NSLocalizedString(
					"\(error)",
					comment: "Raw Error"
				)
		}
	}
}
