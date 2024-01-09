//
//  CalendarEvent.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2024-01-08.
//

import Foundation

struct CalendarEvent: Identifiable, Hashable {
	enum Event: Identifiable, Hashable {
		case order(Order)
		case timeBlock(TimeBlock)
		
		var id: String {
			switch self {
			case .order(let order):
				return order.id
			case .timeBlock(let timeBlock):
				return timeBlock.id
			}
		}
	}
	
	let event: Event
	
	var id: String {
		switch event {
		case .order(let order):
			return "order:\(order.id)"
		case .timeBlock(let timeBlock):
			return "timeBlock:\(timeBlock.id)"
		}
	}
	
	var startTimeDate: Date {
		switch event {
		case .order(let order):
			return order.startTimeDate
		case .timeBlock(let timeBlock):
			return timeBlock.startTimeDate
		}
	}
	
	var endTimeDate: Date {
		switch event {
		case .order(let order):
			return order.endTimeDate
		case .timeBlock(let timeBlock):
			return timeBlock.endTimeDate
		}
	}
}
