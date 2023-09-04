//
//  Array+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-03.
//

import Foundation

extension Array {
	subscript(safe index: Int) -> Element? {
		guard indices.contains(index) else {
			return nil
		}
		return self[index]
	}
}
