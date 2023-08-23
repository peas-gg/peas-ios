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

extension Business {
	static let mock1: Self = {
		return Business(
			id: UUID().uuidString,
			sign: "testBusiness",
			name: "The Hair shop",
			category: "Hair",
			color: "#9ED2BE",
			description: "Box braids, cornrows, twists? I got you covered. I offer all forms of braiding styles for both men and women. Select a package and I will transform ya",
			profilePhoto: "https://peasfilesdev.blob.core.windows.net/images/Jenny.jpg",
			twitter: "",
			instagram: "",
			tiktok: "",
			location: "Vancouver, BC. Canada",
			timeZone: "America/Los Angeles",
			isActive: true
		)
	}()
}
