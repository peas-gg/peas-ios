//
//  APIClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-18.
//

import Combine
import Foundation
import UIKit

typealias APIClientError = AppError.APIClientError

protocol APIRequests {
	//Business
	func getImage(url: URL) async -> UIImage?
	func getTemplates() -> AnyPublisher<[Template], APIClientError>
	func getColours() -> AnyPublisher<Dictionary<String, String>, APIClientError>
}

final class APIClient: APIRequests {
	static let shared: APIClient = APIClient()
	
	private let queue = DispatchQueue(label: "com.strikingFinancial.business.peas.api.sessionQueue", target: .global())
	
	private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
	
	let decoder: JSONDecoder = JSONDecoder()
	
	func getImage(url: URL) async -> UIImage? {
		await withCheckedContinuation { continuation in
			queue.async { [weak self] in
				guard let self = self else { return }
				self.urlRequest(urlRequest: URLRequest(url: url))
					.sink(
						receiveCompletion: { completion in
							switch completion {
							case .finished: return
							case .failure:
								continuation.resume(with: .success(nil))
								return
							}
						},
						receiveValue: { data in
							continuation.resume(with: .success(UIImage(data: data)))
						}
					)
					.store(in: &self.cancellables)
			}
		}
	}
	
	func getTemplates() -> AnyPublisher<[Template], APIClientError> {
		let getTemplates = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["business", "doesAccountExist"]
		)
		return apiRequest(appRequest: getTemplates, output: [Template].self)
	}
	
	func getColours() -> AnyPublisher<Dictionary<String, String>, APIClientError> {
		let getColors = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["business", "colours"]
		)
		return apiRequest(appRequest: getColors, output: Dictionary<String, String>.self)
	}
	
	private func apiRequest<Output: Decodable>(appRequest: APPUrlRequest, output: Output.Type) -> AnyPublisher<Output, APIClientError> {
		do {
			return try urlRequest(urlRequest: appRequest.urlRequest)
				.catch { error -> AnyPublisher<Data, Error> in
					let failedPublisher: AnyPublisher<Data, Error> = Fail(error: error).eraseToAnyPublisher()
					if let error  = error as? APIClientError {
						if error == .authExpired {
							return TokenManager.shared.refreshToken()
								.flatMap { isSuccess -> AnyPublisher<Data, Error> in
									let request = try! appRequest.urlRequest
									if isSuccess {
										return self.urlRequest(urlRequest: request)
											.eraseToAnyPublisher()
									} else {
										return failedPublisher
									}
								}
								.eraseToAnyPublisher()
						} else {
							return failedPublisher
						}
					} else {
						return failedPublisher
					}
				}
				.decode(type: output, decoder: self.decoder)
				.mapError{ error in
					if let error = error as? AppError.APIClientError {
						return error
					}
					else {
						return APIClientError.rawError(String(describing: error))
					}
				}
				.eraseToAnyPublisher()
		}
		catch let error {
			return Fail(error: APIClientError.rawError(String(describing: error)))
					.eraseToAnyPublisher()
		}
	}
	
	func urlRequest(urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
		return URLSession.shared.dataTaskPublisher(for: urlRequest)
			.validateStatusCode()
			.map(\.data)
			.eraseToAnyPublisher()
	}
}
