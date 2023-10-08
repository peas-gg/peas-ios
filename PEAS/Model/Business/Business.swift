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
		let index: Int
		let blockType: BlockType
		var image: URL
		var price: Int
		var duration: Int
		var title: String
		var description: String
		let isActive: Bool
	}
	
	struct Schedule: Codable, Equatable, Identifiable {
		let id: String
		let dayOfWeek: Int
		var startTime: String
		var endTime: String
	}
	
	let id: String
	var sign: String
	var name: String
	let category: String
	var color: String
	var description: String
	var profilePhoto: URL
	let orderCount: Int
	var twitter: String?
	var instagram: String?
	var tiktok: String?
	var location: String
	var latitude: Double?
	var longitude: Double?
	let timeZone: String
	let isActive: Bool
	var blocks: IdentifiedArrayOf<Block>
	var schedules: IdentifiedArrayOf<Schedule>?
}

extension Business {
	var hasSetLocation: Bool {
		latitude != nil && longitude != nil
	}
}

extension Business.Schedule {
	var startTimeDate: Date {
		ServerDateFormatter.formatToLocal(from: self.startTime)
	}
	var endTimeDate: Date {
		ServerDateFormatter.formatToLocal(from: self.endTime)
	}
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
			profilePhoto: URL(string: "https://peasfiles.blob.core.windows.net/templates/jenny.jpg")!,
			orderCount: 20,
			twitter: nil,
			instagram: nil,
			tiktok: nil,
			location: "Toronto, ON. Canada",
			latitude: nil,
			longitude: nil,
			timeZone: "America/Los Angeles",
			isActive: true,
			blocks: [
				Block(
					id: "1",
					index: 0,
					blockType: .Genesis,
					image: URL(string: "https://peasfiles.blob.core.windows.net/templates/jenny_block_1.jpg")!,
					price: 13299,
					duration: 14400,
					title: "Haircuts & hair dyes",
					description: "This will take approximately 4 hours on average. But please add a note if you have any special request.",
					isActive: true
				),
				Block(
					id: "2",
					index: 1,
					blockType: .Genesis,
					image: URL(string: "https://peasfiles.blob.core.windows.net/templates/jenny_block_2.jpg")!,
					price: 2999,
					duration: 7200,
					title: "I am just trying this out",
					description: "This will take approximately 4 hours on average. But please add a note if you have any special request.",
					isActive: true
				),
				Block(
					id: "3",
					index: 2,
					blockType: .Genesis,
					image: URL(string: "https://peasfiles.blob.core.windows.net/templates/jenny_block_2.jpg")!,
					price: 400,
					duration: 600,
					title: "I am just trying this out",
					description: "This will take approximately 4 hours on average. But please add a note if you have any special request.",
					isActive: true
				),
				Block(
					id: "4",
					index: 3,
					blockType: .Genesis,
					image: URL(string: "https://peasfiles.blob.core.windows.net/templates/jenny_block_2.jpg")!,
					price: 400,
					duration: 14000,
					title: "I am just trying this out",
					description: "This will take approximately 4 hours on average. But please add a note if you have any special request.",
					isActive: true
				)
			],
			schedules: [
				Schedule(
					id: UUID().uuidString,
					dayOfWeek: 1,
					startTime: "2023-09-21T02:30:36.52438Z",
					endTime: "2023-09-21T08:30:36.52438Z"
				),
				Schedule(
					id: UUID().uuidString,
					dayOfWeek: 2,
					startTime: "2023-09-21T03:30:36.52438Z",
					endTime: "2023-09-21T08:30:36.52438Z"
				)
			]
		)
	}()
}
