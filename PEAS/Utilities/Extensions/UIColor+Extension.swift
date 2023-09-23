//
//  UIColor+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import UIKit

extension UIColor {
	convenience init(hex: String) {
		var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}
		
		if ((cString.count) != 6) {
			self.init(.gray)
		}
		
		var rgbValue:UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)
		
		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}

extension UIColor {
	static func generateColor(text: String) -> UIColor{
		var hash = 0
		let colorConstant = 131
		let maxSafeValue = Int.max / colorConstant
		for char in text.unicodeScalars{
			if hash > maxSafeValue {
				hash = hash / colorConstant
			}
			hash = Int(char.value) + ((hash << 5) - hash)
		}
		let finalHash = abs(hash) % (256*256*256)
		let color = UIColor(red: CGFloat((finalHash & 0xFF0000) >> 16) / 255.0, green: CGFloat((finalHash & 0xFF00) >> 8) / 255.0, blue: CGFloat((finalHash & 0xFF)) / 255.0, alpha: 1.0)
		return color
	}
}
