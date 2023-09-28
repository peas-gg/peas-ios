//
//  Order.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import Foundation
import SwiftUI

struct Order: Codable, Identifiable, Hashable {
	enum Status: String, Codable, CaseIterable, Equatable, Identifiable, Hashable {
		case Pending
		case Approved
		case Declined
		case Completed
		
		var id: String { self.rawValue }
		
		var foregroundColor: Color {
			switch self {
			case .Pending: return Color.app.pendingText
			case .Approved: return Color.app.approvedText
			case .Declined: return Color.app.declinedText
			case .Completed: return Color.app.completedText
			}
		}
		
		var backgroundColor: Color {
			switch self {
			case .Pending: return Color.app.pendingBackground
			case .Approved: return Color.app.approvedBackground
			case .Declined: return Color.app.declinedBackground
			case .Completed: return Color.app.completedBackground
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
	let payment: Payment?
	let created: String
}

extension Order {
	var didRequestPayment: Bool {
		
	}
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
			orderStatus: .Approved,
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
			orderStatus: .Pending,
			didRequestPayment: false,
			payment: nil,
			created: "2023-09-22T07:10:00Z"
		)
	}
	
	static var mock3: Self {
		return Order(
			id: UUID().uuidString,
			customer: Customer.mock1,
			currency: .CAD,
			price: 12000,
			title: "Box Braids",
			description: "I could offer you some discounts if you have shorter hair",
			image: URL(string: "https://peasfilesdev.blob.core.windows.net/images/jenny_block_1.jpg")!,
			note: "Would it be possible to add some coloured extensions as well? I am happy to pay a little extra for the extensions",
			startTime: "2023-09-28T22:00:00Z",
			endTime: "2023-09-28T23:10:00Z",
			orderStatus: .Pending,
			didRequestPayment: false,
			payment: nil,
			created: "2023-09-22T07:10:00Z"
		)
	}
}
