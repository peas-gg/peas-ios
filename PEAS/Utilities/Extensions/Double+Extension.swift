//
//  Double+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-28.
//

import Foundation

extension Double {
	var priceToText: String {
		return String(Int((self / 0.01)))
	}
}
