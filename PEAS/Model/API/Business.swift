//
//  Business.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Foundation

struct Business: Codable, Equatable {
	struct Block: Codable, Equatable {
		let id: String
		let blockType: String
		let image: URL
		let price: Double
		let duration: Int
		let title: String
		let description: String
	}
	
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
	let blocks: [Block]
}

extension Business {
	static let mock1: Self = {
		return Business(
			id: UUID().uuidString,
			sign: "testBusiness",
			name: "The Hair shop",
			category: "Hair",
			color: "Berry",
			description: "Box braids, cornrows, twists? I got you covered. I offer all forms of braiding styles for both men and women. Select a package and I will transform ya",
			profilePhoto: "https://peasfilesdev.blob.core.windows.net/images/Jenny.jpg",
			twitter: "",
			instagram: "",
			tiktok: "",
			location: "Vancouver, BC. Canada",
			timeZone: "America/Los Angeles",
			isActive: true,
			blocks: [
				Block(
					id: "1",
					blockType: "Genesis",
					image: URL(string: "https://peasfilesdev.blob.core.windows.net/images/Jenny.jpg")!,
					price: 40.0,
					duration: 14000,
					title: "I am just trying this out",
					description: "This will take approximately 4 hours on average. But please add a note if you have any special request."
				)
			]
		)
	}()
}
