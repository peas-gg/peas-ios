//
//  CalendarActivity.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2024-01-08.
//

import Foundation

struct CalendarActivity {
	enum Activity {
		case order(Order)
		case timeBlock(TimeBlock)
	}
	
	let activity: Activity
	
	var startTimeDate: Date {
		switch activity {
		case .order(let order):
			return order.startTimeDate
		case .timeBlock(let timeBlock):
			return timeBlock.startTimeDate
		}
	}
	
	var endTimeDate: Date {
		switch activity {
		case .order(let order):
			return order.endTimeDate
		case .timeBlock(let timeBlock):
			return timeBlock.endTimeDate
		}
	}
}
