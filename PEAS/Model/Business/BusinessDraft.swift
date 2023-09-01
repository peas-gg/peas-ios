//
//  BusinessDraft.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import Foundation

struct BusinessDraft: Codable, Equatable {
	var business: Business
	var latitude: Double?
	var longitude: Double?
}
