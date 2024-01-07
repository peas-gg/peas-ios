//
//  TokenManager.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Combine
import Foundation

extension APIClient {
	class TokenManager {
		static let shared: TokenManager = TokenManager()
		
		private let queue = DispatchQueue(label: "com.strikingFinancial.business.peas.tokenManager.sessionQueue", target: .global())
		
		private let decoder: JSONDecoder = JSONDecoder()
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		private var isRefreshing: Bool = false
		private var lastRefreshed: Date?
		
		var canRefresh: Bool {
			if let lastRefreshed = lastRefreshed {
				return Date.now.timeIntervalSince(lastRefreshed) > 60
			}
			return true
		}
		
		//Clients
		private let keychainClient: KeychainClient = KeychainClient.shared
		
		init() {
			
		}
		
		func refreshToken() -> Future<Bool, APIClientError> {
			return Future { promise in
				self.queue.sync {
					do {
						if !self.isRefreshing && self.canRefresh {
							self.isRefreshing = true
							if let user = self.keychainClient.get(key: .user), let cookie = HTTPCookie(properties: [
								.domain: ServerUrl.shared.server.domain,
								.path: "/",
								.name: "refreshToken",
								.value: user.refreshToken,
								.secure: "FALSE",
								.discard: "TRUE"
							]) {
								HTTPCookieStorage.shared.setCookie(cookie)
							}
							let tokenRequest: URLRequest = try APPUrlRequest(httpMethod: .post, pathComponents: ["account", "refresh"]).urlRequest()
							
							APIClient.shared.urlRequest(urlRequest: tokenRequest)
								.receive(on: DispatchQueue.main)
								.decode(type: AuthenticateResponse.self, decoder: self.decoder)
								.mapError{ $0 as? AppError.APIClientError ?? APIClientError.rawError($0.localizedDescription) }
								.sink(receiveCompletion: { completion in
									switch completion {
									case .finished:
										return
									case .failure(let error):
										let expectedDataError: Data = Data("Invalid token".utf8)
										if error == .httpError(statusCode: 400, data: expectedDataError) {
											Task {
												//Log User Out
												await AppState.shared.logUserOut(isUserRequested: false)
											}
										} else {
											self.isRefreshing = false
										}
										promise(.success(false))
									}
								}, receiveValue: { authResponse in
									let user = User(
										id: authResponse.id,
										firstName: authResponse.firstName,
										lastName: authResponse.lastName,
										email: authResponse.email,
										interacEmail: authResponse.interacEmail,
										phone: authResponse.phone,
										role: authResponse.role,
										accessToken: authResponse.jwtToken,
										refreshToken: authResponse.refreshToken
									)
									self.keychainClient.set(key: .user, value: user)
									self.lastRefreshed = Date.now
									self.isRefreshing = false
									promise(.success(true))
								})
								.store(in: &self.cancellableBag)
						}
						else {
							//Token was just refreshed so return true
							promise(.success(true))
						}
					} catch {
						promise(.failure(APIClientError.rawError("Could not refresh auth token")))
					}
				}
			}
		}
	}
}
