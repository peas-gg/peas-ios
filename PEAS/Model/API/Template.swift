//
//  Template.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-21.
//

import Foundation

struct Template: Codable, Identifiable {
	let id: String
	let category: String
	let details: String
	let photo: URL
	let business: Business
}


extension Template {
	static let mock1: Self = {
		return Template(
			id: "A",
			category: "Model",
			details: "",
			photo: URL(string: "https://peasfilesdev.blob.core.windows.net/templates/Model.jpg")!,
			business: Business.mock1
		)
	}()
}
