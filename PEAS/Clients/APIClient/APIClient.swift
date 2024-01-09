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
	//Account
	func setInteracEmail(_ email: String) -> AnyPublisher<String, APIClientError>
	func addDevice(_ token: String) -> AnyPublisher<EmptyResponse, APIClientError>
	//Business
	func getBusinessAccount() -> AnyPublisher<Business, APIClientError>
	func createBusiness(_ model: CreateBusiness) -> AnyPublisher<Business, APIClientError>
	func updateBusiness(_ model: UpdateBusiness) -> AnyPublisher<Business, APIClientError>
	func setSchedule(businessId: Business.ID, _ model: [Business.Schedule]) -> AnyPublisher<Business, APIClientError>
	func addBlock(businessId: Business.ID, _ model : Business.Block) -> AnyPublisher<Business, APIClientError>
	func updateBlock(businessId: Business.ID, _ model: UpdateBusiness.Block) -> AnyPublisher<Business, APIClientError>
	func deleteBlock(businessId: Business.ID, blockId: Business.Block.ID) -> AnyPublisher<Business, APIClientError>
	func getOrders(businessId: Business.ID) -> AnyPublisher<[OrderResponse], APIClientError>
	func updateOrder(businessId: Business.ID, _ model: UpdateOrder) -> AnyPublisher<OrderResponse, APIClientError>
	func getTimeBlocks(businessId: Business.ID) -> AnyPublisher<[TimeBlockResponse], APIClientError>
	func createTimeBlock(businessId: Business.ID, _ model: CreateTimeBlock) -> AnyPublisher<TimeBlockResponse, APIClientError>
	func requestPayment(businessId: Business.ID, _ model: RequestPayment) -> AnyPublisher<OrderResponse, APIClientError>
	func getCustomers(businessId: Business.ID) -> AnyPublisher<[Customer], APIClientError>
	func getWallet(businessId: Business.ID) -> AnyPublisher<WalletResponse, APIClientError>
	func withdraw(businessId: Business.ID) -> AnyPublisher<WalletResponse, APIClientError>
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
	
	func uploadImage(localUrl: URL) async -> URL? {
		let fetchImageTask = Task { () -> Data? in
			if let image = await CacheClient.shared.getImage(url: localUrl) {
				return image.jpegData(compressionQuality: 1.0)
			}
			return nil
		}
		if let imageData = await fetchImageTask.value {
			return await uploadImage(imageData: imageData)
		}
		return nil
	}
	
	//MARK: Business
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
			query: [URLQueryItem(name: "businessId", value: businessId)],
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
	
	func getOrders(businessId: Business.ID) -> AnyPublisher<[OrderResponse], APIClientError> {
		let getOrders = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["business", "orders"],
			query: [
				URLQueryItem(name: "businessId", value: businessId),
			],
			requiresAuth: true
		)
		return apiRequest(appRequest: getOrders, output: [OrderResponse].self)
	}
	
	func updateOrder(businessId: Business.ID, _ model: UpdateOrder) -> AnyPublisher<OrderResponse, APIClientError> {
		let updateOrder = APPUrlRequest(
			httpMethod: .patch,
			pathComponents: ["business", "order"],
			query: [
				URLQueryItem(name: "businessId", value: businessId),
			],
			body: model,
			requiresAuth: true
		)
		return apiRequest(appRequest: updateOrder, output: OrderResponse.self)
	}
	
	func getTimeBlocks(businessId: Business.ID) -> AnyPublisher<[TimeBlockResponse], APIClientError> {
		let getTimeBlocks = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["business", "time", "block"],
			query: [
				URLQueryItem(name: "businessId", value: businessId),
			],
			requiresAuth: true
		)
		return apiRequest(appRequest: getTimeBlocks, output: [TimeBlockResponse].self)
	}
	
	func createTimeBlock(businessId: Business.ID, _ model: CreateTimeBlock) -> AnyPublisher<TimeBlockResponse, APIClientError> {
		let createTimeBlock = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["business", "time", "block"],
			query: [
				URLQueryItem(name: "businessId", value: businessId),
			],
			body: model,
			requiresAuth: true
		)
		return apiRequest(appRequest: createTimeBlock, output: TimeBlockResponse.self)
	}
	
	func requestPayment(businessId: Business.ID, _ model: RequestPayment) -> AnyPublisher<OrderResponse, APIClientError> {
		let requestPayment = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["business", "payment"],
			query: [
				URLQueryItem(name: "businessId", value: businessId),
			],
			body: model,
			requiresAuth: true
		)
		return apiRequest(appRequest: requestPayment, output: OrderResponse.self)
	}
	
	func getCustomers(businessId: Business.ID) -> AnyPublisher<[Customer], APIClientError> {
		let getCustomers = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["business", "customers"],
			query: [
				URLQueryItem(name: "businessId", value: businessId),
			],
			requiresAuth: true
		)
		return apiRequest(appRequest: getCustomers, output: [Customer].self)
	}
	
	func getWallet(businessId: Business.ID) -> AnyPublisher<WalletResponse, APIClientError> {
		let getWallet = APPUrlRequest(
			httpMethod: .get,
			pathComponents: ["business", "wallet"],
			query: [
				URLQueryItem(name: "businessId", value: businessId),
			],
			requiresAuth: true
		)
		return apiRequest(appRequest: getWallet, output: WalletResponse.self)
	}
	
	func withdraw(businessId: Business.ID) -> AnyPublisher<WalletResponse, APIClientError> {
		let withdraw = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["business", "wallet", "withdraw"],
			query: [
				URLQueryItem(name: "businessId", value: businessId),
			],
			requiresAuth: true
		)
		return apiRequest(appRequest: withdraw, output: WalletResponse.self)
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
	
	func setInteracEmail(_ email: String) -> AnyPublisher<String, APIClientError> {
		let setInteracEmailRequest = APPUrlRequest(
			httpMethod: .patch,
			pathComponents: ["account", "interacEmail"],
			query: [URLQueryItem(name: "email", value: email)],
			requiresAuth: true
		)
		return apiRequest(appRequest: setInteracEmailRequest, output: String.self)
	}
	
	func addDevice(_ token: String) -> AnyPublisher<EmptyResponse, APIClientError> {
		let addDeviceRequest = APPUrlRequest(
			httpMethod: .post,
			pathComponents: ["account", "device"],
			query: [
				URLQueryItem(name: "token", value: token),
				URLQueryItem(name: "deviceType", value: "Apple")
			],
			requiresAuth: true
		)
		return apiRequest(appRequest: addDeviceRequest, output: EmptyResponse.self)
	}
	
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
			return try urlRequest(urlRequest: appRequest.urlRequest())
				.catch { error -> AnyPublisher<Data, Error> in
					let failedPublisher: AnyPublisher<Data, Error> = Fail(error: error).eraseToAnyPublisher()
					if let error  = error as? APIClientError {
						if error == .authExpired {
							return TokenManager.shared
								.refreshToken()
								.mapError { $0 as Error }
								.flatMap { didRefresh -> AnyPublisher<Data, Error> in
									guard didRefresh,
										  let request = try? appRequest.urlRequest()
									else {
										return failedPublisher
									}
									return self.urlRequest(urlRequest: request)
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
				.mapError { error in
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
