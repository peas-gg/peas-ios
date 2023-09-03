//
//  String+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-29.
//

import Foundation

extension String {
	var textToPrice: Double {
		return Double(Int(self) ?? 0) * 0.01
	}
	
	var unwrappedContentUrl: URL { URL(string: self) ?? URL(string: "https://invalidContent.com")! }
}
