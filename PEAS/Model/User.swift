//
//  User.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Foundation

struct User: Codable {
	let firstName: String
	let lastName: String
	let email: String
	let interacEmail: String?
	let phone: String
	let role: String
	let accessToken: String
	let refreshToken: String
}
