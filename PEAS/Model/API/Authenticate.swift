//
//  Authenticate.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Foundation

struct AuthenticateRequest: Encodable {
	let email: String
	let password: String
	let code: String?
}

struct AuthenticateResponse: Decodable {
	let id: String
	let firstName: String
	let lastName: String
	let email: String
	let interacEmail: String?
	let phone: String
	let role: String
	let jwtToken: String
	let refreshToken: String
}

struct RegisterRequest: Encodable {
	let firstName: String
	let lastName: String
	let email: String
	let phone: String
	let passwordText: String
	let code: String
	let acceptTerms: Bool
}

struct ResetPasswordRequest: Encodable {
	let email: String
	let password: String
	let code: String
}
