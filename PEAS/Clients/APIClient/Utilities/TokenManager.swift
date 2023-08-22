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
		private let queue = DispatchQueue(label: "com.strikingFinancial.business.peas.token.sessionQueue", target: .global())
		
		private let decoder: JSONDecoder = JSONDecoder()
		
		private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
		private var isRefreshing: Bool = false
		private var lastRefreshed: Date?
		
		//Clients
		private let keychainClient: KeychainClient = KeychainClient.shared
		
		func refreshToken() -> Future<Bool, Never> {
			return Future { [weak self] promise in
				guard let self = self else { return }
				self.queue.sync {
					do {
						//Force a refresh if it has been more than one minute since the last refresh
						if self.lastRefreshed == nil {
							self.lastRefreshed = Date.now
						}
						if Date.now.timeIntervalSince(self.lastRefreshed!) > 1.0 {
							self.isRefreshing = false
						}
						if !self.isRefreshing {
							self.isRefreshing = true
							if let token = self.keychainClient.get(key: .token), let cookie = HTTPCookie(properties: [
								.domain: APPUrlRequest.domain,
								.path: "/",
								.name: "refreshToken",
								.value: token.refresh,
								.secure: "FALSE",
								.discard: "TRUE"
							]) {
								HTTPCookieStorage.shared.setCookie(cookie)
							}
							let tokenRequest: URLRequest = try APPUrlRequest(httpMethod: .post, pathComponents: ["account", "refresh"]).urlRequest
							
							APIClient.shared.urlRequest(urlRequest: tokenRequest)
								.receive(on: self.queue)
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
//												await AppState.updateAppState(with: .logUserOut)
											}
										}
										promise(.success(false))
									}
								}, receiveValue: { authResponse in
									let token = Token(access: authResponse.jwtToken, refresh: authResponse.refreshToken)
									let user = User(
										firstName: authResponse.firstName,
										lastName: authResponse.lastName,
										email: authResponse.email,
										phone: authResponse.phone,
										role: authResponse.role
									)
									self.keychainClient.set(key: .token, value: token)
									self.keychainClient.set(key: .user, value: user)
									self.lastRefreshed = Date.now
									self.isRefreshing = false
									promise(.success(true))
								})
								.store(in: &self.cancellables)
						} else {
							promise(.success(true))
						}
					} catch {
						promise(.success(true))
					}
				}
			}
		}
	}
}
