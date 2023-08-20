//
//  URLSession+Validation.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-18.
//

import Combine
import Foundation

extension URLSession.DataTaskPublisher {
	func validateStatusCode() -> AnyPublisher<Output, Error> {
		return tryMap { data, response in
			if let response = response as? HTTPURLResponse, (400..<600).contains(response.statusCode) {
				if response.statusCode == 401 {
					throw AppError.APIClientError.authExpired
				}
				if let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
					throw AppError.APIClientError.httpError(statusCode: response.statusCode, data: Data(errorMessage.message.utf8))
				}
				else {
					throw AppError.APIClientError.httpError(statusCode: response.statusCode, data: data.isEmpty ? "Something went wrong".data(using: .utf8)! : data)
				}
			} else {
				return (data, response)
			}
		}
		.eraseToAnyPublisher()
	}
}
