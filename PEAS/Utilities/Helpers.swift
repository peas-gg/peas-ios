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
	static let descriptionLimit: Int = 120
	static let detentHeight: CGFloat = 400
	static let scrollViewBottomPadding: CGFloat = 60
	static let otpCodeCount: Int = 6
	static let minimumPasswordCharactersCount: Int = 8
}

struct AppConstants {
#if DEBUG
	static let appUrlString: String = "https://dev.peas.gg/"
#else
	static let appUrlString: String = "https://peas.gg/"
#endif
	static let twitterUrlString: String = "https://x.com/"
	static let instagramUrlString: String = "https://instagram.com/"
	static let tiktokUrlString: String = "https://tiktok.com/"
	static let keypadDelete: String = "delete"
}
