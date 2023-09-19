//
//  CreateBusiness.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import Foundation
import IdentifiedCollections

struct CreateBusiness: Codable, Equatable {
	var sign: String
	var name: String
	var category: String
	var color: String
	var description: String
	var profilePhoto: URL
	var twitter: String?
	var instagram: String?
	var tiktok: String?
	var latitude: Double
	var longitude: Double
	var blocks: IdentifiedArrayOf<Business.Block>
}
