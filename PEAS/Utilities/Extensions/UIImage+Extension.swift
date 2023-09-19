//
//  UIImage+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-19.
//

import UIKit

extension UIImage {
	func resized(withPercentage percentage: CGFloat) -> UIImage? {
		let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
		UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
		defer { UIGraphicsEndImageContext() }
		draw(in: CGRect(origin: .zero, size: canvasSize))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	func resizedTo(megaBytes: Double) -> UIImage? {
		guard let imageData = self.pngData() else { return nil }
		let scale = megaBytes * 1024.0
		
		var resizingImage = self
		var imageSizeKB = Double(imageData.count) / scale
		
		while imageSizeKB > scale {
			guard let resizedImage = resizingImage.resized(withPercentage: 0.5),
				  let imageData = resizedImage.pngData() else { return nil }
			
			resizingImage = resizedImage
			imageSizeKB = Double(imageData.count) / scale
		}
		return resizingImage
	}
}
