//
//  Binding+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-28.
//

import SwiftUI

extension Binding where Value == String {
	func max(_ limit: Int) -> Self {
		if self.wrappedValue.count > limit {
			DispatchQueue.main.async {
				self.wrappedValue = String(self.wrappedValue.dropLast())
			}
		}
		return self
	}
}
