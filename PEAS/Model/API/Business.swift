//
//  Business.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Foundation

struct Business: Codable {
	let id: String
	let sign: String
	let name: String
	let category: String
	let color: String
	let description: String
	let profilePhoto: String
	let twitter: String
	let instagram: String
	let tiktok: String
	let location: String
	let timeZone: String
	let isActive: Bool
}
