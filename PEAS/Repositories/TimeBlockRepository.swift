//
//  TimeBlockRepository.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2024-01-08.
//

import Foundation
import IdentifiedCollections

@MainActor class TimeBlockRepository: ObservableObject {
	static let shared: TimeBlockRepository = TimeBlockRepository()
	
	@Published var timeBlocks: IdentifiedArrayOf<TimeBlock> = []
	
	//Clients
	private let cacheClient: CacheClient = CacheClient.shared
	
	init() {
		setUp()
	}
	
	func update(timeBlock: TimeBlock) {
		self.timeBlocks.updateOrAppend(timeBlock)
		update()
	}
	
	func update(timeBlocks: [TimeBlock]) {
		self.timeBlocks = IdentifiedArray(uniqueElements: timeBlocks)
		update()
	}
	
	func delete(timeBlock: TimeBlock) {
		self.timeBlocks.remove(id: timeBlock.id)
		update()
	}
	
	private func setUp() {
		Task {
			if let timeBlocks = await cacheClient.getData(key: .timeBlocks) {
				self.timeBlocks = timeBlocks
			}
		}
	}
	
	private func update() {
		Task {
			await cacheClient.setData(key: .timeBlocks, value: self.timeBlocks)
		}
	}
}
