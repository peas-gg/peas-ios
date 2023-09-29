//
//  BannerData.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-05.
//

import Foundation

struct BannerData: Equatable {
	var timeOut: Double = 4.0
	var detail: String
}

extension BannerData {
	init(error: AppError.APIClientError) {
		switch error {
		case .httpError(statusCode: let statusCode, data: _):
			if statusCode < 500 {
				self.init(detail: error.errorDescription ?? "Something went wrong 1000")
			} else {
				self.init(detail: "Something went wrong 1001")
			}
		case .authExpired:
			self.init(detail: "")
		case .rawError(let description):
			if description.contains("1001") || description.contains("1020") {
				self.init(detail: "Not connected to the internet")
			} else {
				self.init(detail: error.errorDescription ?? "Something went wrong 1002")
			}
		default:
			self.init(detail: error.errorDescription ?? "Something went wrong 1003")
		}
	}
}
