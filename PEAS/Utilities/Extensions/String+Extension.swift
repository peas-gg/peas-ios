//
//  String+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-29.
//

import Foundation

extension String {
	var unwrappedContentUrl: URL { URL(string: self) ?? URL(string: "https://invalidContent.com")! }
	
	var isValidName: Bool {
		!self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}
	
	var isValidPassword: Bool {
		self.count >= SizeConstants.minimumPasswordCharactersCount
	}
	
	var isValidEmail: Bool {
		guard let emailRegex = try? Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
		else { return false }
		return self.firstMatch(of: emailRegex) != nil
	}
}
