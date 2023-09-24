//
//  Order.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import Foundation
import SwiftUI

struct Order: Codable, Identifiable {
	enum Status: String, Codable, CaseIterable, Equatable, Identifiable {
		case pending
		case approved
		case declined
		case completed
		
		var id: String { self.rawValue }
		
		var foregroundColor: Color {
			switch self {
			case .pending: return Color.app.pendingText
			case .approved: return Color.app.approvedText
			case .declined: return Color.app.declinedText
			case .completed: return Color.app.completedText
			}
		}
		
		var backgroundColor: Color {
			switch self {
			case .pending: return Color.app.pendingBackground
			case .approved: return Color.app.approvedBackground
			case .declined: return Color.app.declinedBackground
			case .completed: return Color.app.completedBackground
			}
		}
	}
	
	let id: String
	let customer: Customer
	let currency: Currency
	let price: Int
	let title: String
	let description: String
	let image: URL
	let note: String?
	let startTime: String
	let endTime: String
	let orderStatus: Status
	let didRequestPayment: Bool
	let payment: Payment?
	let created: String
}

extension Order {
	var startTimeDate: Date {
		ServerDateFormatter.formatToLocal(from: self.startTime)
	}
	var endTimeDate: Date {
		ServerDateFormatter.formatToLocal(from: self.endTime)
	}
}

extension Order {
	static var mock1: Self {
		return Order(
			id: UUID().uuidString,
			customer: Customer.mock1,
			currency: .CAD,
			price: 12000,
			title: "Box Braids",
			description: "I could offer you some discounts if you have shorter hair",
			image: URL(string: "https://peasfilesdev.blob.core.windows.net/images/jenny_block_1.jpg")!,
			note: "Would it be possible to add some coloured extensions as well? I am happy to pay a little extra for the extensions",
			startTime: "2023-09-22T07:00:00Z",
			endTime: "2023-09-22T07:10:00Z",
			orderStatus: .pending,
			didRequestPayment: false,
			payment: nil,
			created: "2023-09-22T07:10:00Z"
		)
	}
	
	static var mock2: Self {
		return Order(
			id: UUID().uuidString,
			customer: Customer.mock1,
			currency: .CAD,
			price: 12000,
			title: "Box Braids",
			description: "I could offer you some discounts if you have shorter hair",
			image: URL(string: "https://peasfilesdev.blob.core.windows.net/images/jenny_block_1.jpg")!,
			note: "Would it be possible to add some coloured extensions as well? I am happy to pay a little extra for the extensions",
			startTime: "2023-09-23T22:00:00Z",
			endTime: "2023-09-23T23:10:00Z",
			orderStatus: .completed,
			didRequestPayment: false,
			payment: Payment.mock1,
			created: "2023-09-22T07:10:00Z"
		)
	}
}
