//
//  AppUrlRequest.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Foundation

struct APPUrlRequest {
	let httpMethod: HTTPMethod
	let pathComponents: [String]
	let query: [URLQueryItem]
	let body: Encodable?
	let requiresAuth: Bool
	
	func urlRequest() throws -> URLRequest {
		let baseUrl = URL(string: "https://\(ServerUrl.shared.server.domain)/")
		guard var url = baseUrl else { throw AppError.apiClientError(.invalidURL) }
		for pathComponent in pathComponents {
			url.appendPathComponent(pathComponent)
		}
		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
		components?.queryItems = query
		guard let url = components?.url else { throw AppError.apiClientError(.invalidURL) }
		
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		if requiresAuth, let accessToken = KeychainClient.shared.get(key: .user)?.accessToken {
			request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		}
		
		if let body = body, httpMethod != .get {
			request.httpBody = try JSONEncoder().encode(body)
		}
		
		return request
	}
	
	init(
		httpMethod: HTTPMethod,
		pathComponents: [String],
		query: [URLQueryItem] = [],
		body: Encodable? = nil,
		requiresAuth: Bool = false
	) {
		self.httpMethod = httpMethod
		self.pathComponents = pathComponents
		self.query = query
		self.body = body
		self.requiresAuth = requiresAuth
	}
}
