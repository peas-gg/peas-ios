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
		var image: URL
		var price: Double
		var duration: Int
		var title: String
		var description: String
	}
	
	let id: String
	var sign: String
	var name: String
	let category: String
	var color: String
	var description: String
	var profilePhoto: URL
	var twitter: String
	var instagram: String
	var tiktok: String
	let location: String
	let timeZone: String
	let isActive: Bool
	let blocks: [Block]
}

extension Business {
	static let mock1: Self = {
		return Business(
			id: UUID().uuidString,
			sign: "jenny",
			name: "Jenny With The Hands",
			category: "Hair",
			color: "Celery",
			description: "Box braids, cornrows, twists? I got you covered. I offer all forms of braiding styles for both men and women. Select a package and I will transform ya",
			profilePhoto: URL(string: "https://peasfilesdev.blob.core.windows.net/images/Jenny.jpg")!,
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
