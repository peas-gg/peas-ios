//
//  Business.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Foundation
import IdentifiedCollections

struct Business: Codable, Equatable, Identifiable {
	struct Block: Codable, Equatable, Identifiable {
		enum BlockType: String, Codable, Equatable, Identifiable {
			case Genesis
			
			var id: String { self.rawValue }
		}
		
		let id: String
		let blockType: BlockType
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
	var blocks: IdentifiedArrayOf<Block>
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
			profilePhoto: URL(string: "https://peasfilesdev.blob.core.windows.net/images/jenny.jpg")!,
			twitter: "",
			instagram: "",
			tiktok: "",
			location: "Vancouver, BC. Canada",
			timeZone: "America/Los Angeles",
			isActive: true,
			blocks: [
				Block(
					id: "1",
					blockType: .Genesis,
					image: URL(string: "https://peasfilesdev.blob.core.windows.net/images/jenny_block_1.jpg")!,
					price: 132.99,
					duration: 14400,
					title: "Haircuts & hair dyes",
					description: "This will take approximately 4 hours on average. But please add a note if you have any special request."
				),
				Block(
					id: "2",
					blockType: .Genesis,
					image: URL(string: "https://peasfilesdev.blob.core.windows.net/images/jenny_block_2.jpg")!,
					price: 29.99,
					duration: 7200,
					title: "I am just trying this out",
					description: "This will take approximately 4 hours on average. But please add a note if you have any special request."
				),
				Block(
					id: "3",
					blockType: .Genesis,
					image: URL(string: "https://peasfilesdev.blob.core.windows.net/images/jenny_block_2.jpg")!,
					price: 40.0,
					duration: 600,
					title: "I am just trying this out",
					description: "This will take approximately 4 hours on average. But please add a note if you have any special request."
				),
				Block(
					id: "4",
					blockType: .Genesis,
					image: URL(string: "https://peasfilesdev.blob.core.windows.net/images/jenny_block_2.jpg")!,
					price: 40.0,
					duration: 14000,
					title: "I am just trying this out",
					description: "This will take approximately 4 hours on average. But please add a note if you have any special request."
				)
			]
		)
	}()
}
