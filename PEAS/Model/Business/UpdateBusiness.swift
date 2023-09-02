//
//  UpdateBusiness.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import Foundation

struct UpdateBusiness: Identifiable {
	let id: String
	let sign: String?
	let name: String?
	let color: String?
	let description: String?
	let profilePhoto: URL?
	let twitter: String?
	let instagram: String?
	let tiktok: String?
	let latitude: Double?
	let longitude: Double?
}
