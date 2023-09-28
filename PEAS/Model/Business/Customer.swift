//
//  Customer.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import Foundation
import SwiftUI

struct Customer: Codable, Equatable, Hashable, Identifiable {
	let id: Int
	let firstName: String
	let lastName: String
	let email: String
	let phone: String
}

extension Customer {
	var initial: String {
		return "\(firstName.first ?? Character(""))\(lastName.first ?? Character(""))"
	}
	
	var fullName: String {
		return "\(firstName) \(lastName)"
	}
	
	var color: Color {
		Color(uiColor: UIColor.generateColor(text: email))
	}
}

extension Customer {
	static let mock1: Self = {
		return Customer(
			id: 0,
			firstName: "Leonardo",
			lastName: "Brodie",
			email: "leonardo@mail.com",
			phone: "+120488982211"
		)
	}()
	
	static let mock2: Self = {
		return Customer(
			id: 2,
			firstName: "Amir",
			lastName: "Wilde",
			email: "amirwilde@mail.com",
			phone: "+2045678882"
		)
	}()
}
