//
//  User.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Foundation

struct User: Codable {
	let id: String
	let firstName: String
	let lastName: String
	let email: String
	let interacEmail: String?
	let phone: String
	let role: String
	let accessToken: String
	let refreshToken: String
}

extension User {
	static let mock1: Self = {
		return User (
			id: UUID().uuidString,
			firstName: "Melissa",
			lastName: "Kournikova",
			email: "mel.kournikova@gmail.com",
			interacEmail: nil,
			phone: "+16046693332",
			role: "User",
			accessToken: "your-access-token",
			refreshToken: "your-refresh-token"
		)
	}()
}
