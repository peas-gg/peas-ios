//
//  Helpers.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-28.
//

import Foundation
import SwiftUI

struct SizeConstants {
	static let screenSize: CGSize = UIScreen.main.bounds.size
	static let isSmallPhone: Bool = {
		UIScreen.main.bounds.size.height < 700
	}()
	static let avatarHeight: CGFloat = 50
	static let blockCornerRadius: CGFloat = 20
	static let textCornerRadius: CGFloat = 10
	static let businessDescriptionLimit: Int = 160
	static let descriptionLimit: Int = 400
	static let detentHeight: CGFloat = 400
	static let scrollViewBottomPadding: CGFloat = 60
	static let otpCodeCount: Int = 6
	static let minimumPasswordCharactersCount: Int = 8
	static let horizontalPadding: CGFloat = 25
}

struct AppConstants {
	let appUrlString: String = {
		switch ServerUrl.shared.server {
		case .development:
			return "https://dev.peas.gg/"
		case .production:
			return "https://peas.gg/"
		}
	}()
	static let twitterUrlString: String = "https://x.com/"
	static let instagramUrlString: String = "https://instagram.com/"
	static let tiktokUrlString: String = "https://tiktok.com/"
	static let keypadDelete: String = "delete"
}
