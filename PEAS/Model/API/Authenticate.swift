//
//  Authenticate.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Foundation

struct AuthenticateResponse: Decodable {
	let firstName: String
	let lastName: String
	let email: String
	let phone: String
	let role: String
	let jwtToken: String
	let refreshToken: String
}
