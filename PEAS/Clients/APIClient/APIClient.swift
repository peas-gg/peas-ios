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
	//Media
	func uploadImage(imageData: Data) async -> URL?
	func getImage(url: URL) async -> UIImage?
	//Authenticate
	func authenticate(_ model: AuthenticateRequest) -> AnyPublisher<EmptyResponse, APIClientError>
	func authenticateWithCode(_ model: AuthenticateRequest) -> AnyPublisher<AuthenticateResponse, APIClientError>
	func register(_ model: RegisterRequest) -> AnyPublisher<AuthenticateResponse, APIClientError>
	func requestOtpCode(phoneNumber: String) -> AnyPublisher<EmptyResponse, APIClientError>
	func requestPasswordReset(email: String) -> AnyPublisher<EmptyResponse, APIClientError>
	func resetPassword(_ model: ResetPasswordRequest) -> AnyPublisher<EmptyResponse, APIClientError>
	//Business
	func getBusinessAccount() -> AnyPublisher<Business, APIClientError>
	func createBusiness(_ model: CreateBusiness) -> AnyPublisher<Business, APIClientError>
	func updateBusiness(_ model: UpdateBusiness) -> AnyPublisher<Business, APIClientError>
	func setSchedule(businessId: Business.ID, _ model: [Business.Schedule]) -> AnyPublisher<Business, APIClientError>
	func addBlock(businessId: Business.ID, _ model : Business.Block) -> AnyPublisher<Business, APIClientError>
	func updateBlock(businessId: Business.ID, _ model: UpdateBusiness.Block) -> AnyPublisher<Business, APIClientError>
	func deleteBlock(businessId: Business.ID, blockId: Business.Block.ID) -> AnyPublisher<Business, APIClientError>
	func getLocation(latitude: Double, longitude: Double) -> AnyPublisher<String, APIClientError>
	func getTemplates() -> AnyPublisher<[Template], APIClientError>
	func getColours() -> AnyPublisher<Dictionary<String, String>, APIClientError>
}

final class APIClient: APIRequests {
	static let shared: APIClient = APIClient()
	
	private let queue = DispatchQueue(label: "com.strikingFinancial.business.peas.api.sessionQueue", target: .global())
	
	private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
	
	let decoder: JSONDecoder = JSONDecoder()
	
	//MARK: Media
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
					.store(in: &self.cancellableBag)
			}
		}
	}
	
	func uploadImage(imageData: Data) async -> URL? {
		await withCheckedContinuation { continuation in
			queue.async { [weak self] in
				guard let self = self else { return }
				let imageUploadRequest = APPUrlRequest(
					httpMethod: .post,
					pathComponents: ["media", "image"],
					body: imageData
				)
				self.apiRequest(appRequest: imageUploadRequest, output: URL.self)
					.sink(
						receiveCompletion: { completion in
							switch completion {
							case .finished: return
							case .failure:
								continuation.resume(with: .success(nil))
							}
						},
						receiveValue: { url in
							continuation.resume(with: .success(url))
						}
					)
					.store(in: &cancellableBag)
			}
		}
	}
	
	func getBusinessAccount() -> AnyPublisher<Business, APIClientError> {
		let getBusiness = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["business", "account"],
			requiresAuth: true
		)
		return apiRequest(appRequest: getBusiness, output: Business.self)
	}
	
	func createBusiness(_ model: CreateBusiness) -> AnyPublisher<Business, APIClientError> {
		let createBusiness = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["business"],
			body: model,
			requiresAuth: true
		)
		return apiRequest(appRequest: createBusiness, output: Business.self)
	}
	
	func updateBusiness(_ model: UpdateBusiness) -> AnyPublisher<Business, APIClientError> {
		let updateBusiness = APPUrlRequest(
			httpMethod: .patch,
			pathComponents: ["business"],
			body: model,
			requiresAuth: true
		)
		return apiRequest(appRequest: updateBusiness, output: Business.self)
	}
	
	func setSchedule(businessId: Business.ID, _ model: [Business.Schedule]) -> AnyPublisher<Business, APIClientError> {
		let setSchedule = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["business", "schedule"],
			body: model,
			requiresAuth: true
		)
		return apiRequest(appRequest: setSchedule, output: Business.self)
	}
	
	func addBlock(businessId: Business.ID, _ model: Business.Block) -> AnyPublisher<Business, APIClientError> {
		let addBlock = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["business", "block"],
			query: [URLQueryItem(name: "businessId", value: businessId)],
			body: model,
			requiresAuth: true
		)
		return apiRequest(appRequest: addBlock, output: Business.self)
	}
	
	func updateBlock(businessId: Business.ID, _ model: UpdateBusiness.Block) -> AnyPublisher<Business, APIClientError> {
		let updateBlock = APPUrlRequest(
			httpMethod: .patch,
			pathComponents: ["business", "block"],
			query: [URLQueryItem(name: "businessId", value: businessId)],
			body: model,
			requiresAuth: true
		)
		return apiRequest(appRequest: updateBlock, output: Business.self)
	}
	
	func deleteBlock(businessId: Business.ID, blockId: Business.Block.ID) -> AnyPublisher<Business, APIClientError> {
		let deleteBlock = APPUrlRequest(
			httpMethod: .delete,
			pathComponents: ["business", "block"],
			query: [
				URLQueryItem(name: "businessId", value: businessId),
				URLQueryItem(name: "blockId", value: blockId)
			],
			requiresAuth: true
		)
		return apiRequest(appRequest: deleteBlock, output: Business.self)
	}
	
	func getLocation(latitude: Double, longitude: Double) -> AnyPublisher<String, APIClientError> {
		let getLocation = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["business", "location"],
			query: [
				URLQueryItem(name: "latitude", value: String(latitude)),
				URLQueryItem(name: "longitude", value: String(longitude))
			]
		)
		return apiRequest(appRequest: getLocation, output: String.self)
	}
	
	//MARK: Authenticate
	func authenticate(_ model: AuthenticateRequest) -> AnyPublisher<EmptyResponse, APIClientError> {
		let authenticateRequest = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["account", "authenticate"],
			body: model
		)
		return apiRequest(appRequest: authenticateRequest, output: EmptyResponse.self)
	}
	
	func authenticateWithCode(_ model: AuthenticateRequest) -> AnyPublisher<AuthenticateResponse, APIClientError> {
		let authenticateRequest = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["account", "authenticateWithCode"],
			body: model
		)
		return apiRequest(appRequest: authenticateRequest, output: AuthenticateResponse.self)
	}
	
	func register(_ model: RegisterRequest) -> AnyPublisher<AuthenticateResponse, APIClientError> {
		let registerRequest = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["account", "register"],
			body: model
		)
		return apiRequest(appRequest: registerRequest, output: AuthenticateResponse.self)
	}
	
	func requestOtpCode(phoneNumber: String) -> AnyPublisher<EmptyResponse, APIClientError> {
		let otpCodeRequest = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["account", "code"],
			query: [URLQueryItem(name: "number", value: phoneNumber)]
		)
		return apiRequest(appRequest: otpCodeRequest, output: EmptyResponse.self)
	}
	
	func requestPasswordReset(email: String) -> AnyPublisher<EmptyResponse, APIClientError> {
		let requestPasswordResetRequest = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["account", "password", "reset"],
			query: [URLQueryItem(name: "email", value: email)]
		)
		return apiRequest(appRequest: requestPasswordResetRequest, output: EmptyResponse.self)
	}
	
	func resetPassword(_ model: ResetPasswordRequest) -> AnyPublisher<EmptyResponse, APIClientError> {
		let resetPasswordRequest = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["account", "password", "reset"],
			body: model
		)
		return apiRequest(appRequest: resetPasswordRequest, output: EmptyResponse.self)
	}
	
	//MARK: Business
	func getTemplates() -> AnyPublisher<[Template], APIClientError> {
		let getTemplates = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["business", "templates"]
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
