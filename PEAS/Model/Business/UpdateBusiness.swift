//
//  UpdateBusiness.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import Foundation

struct UpdateBusiness: Codable, Identifiable {
	struct Block: Codable, Identifiable {
		let id: String
		var image: URL? = nil
		var price: Int? = nil
		var duration: Int? = nil
		var title: String? = nil
		var description: String? = nil
	}
	
	let id: String
	var sign: String? = nil
	var name: String? = nil
	var color: String? = nil
	var description: String? = nil
	var profilePhoto: URL? = nil
	var twitter: String? = nil
	var instagram: String? = nil
	var tiktok: String? = nil
	var latitude: Double? = nil
	var longitude: Double? = nil
}
