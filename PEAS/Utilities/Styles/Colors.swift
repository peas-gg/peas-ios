//
//  Colors.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

extension Color {
	enum app {}
}

extension Color.app {
	//Main
	static let accent: Color = Color(uiColor: UIColor(hex: "61D361"))
	static let primaryBackground: Color = Color.white
	static let secondaryBackground: Color = Color(uiColor: UIColor(hex: "F4F4F6"))
	
	static let darkGray: Color = Color(uiColor: UIColor(hex: "1E1E1E"))
	
	//Others
	static let primaryText: Color = Color.black
	static let secondaryText: Color = Color.white
	static let tertiaryText: Color = Color(uiColor: UIColor(hex: "A8A8A8"))
	
	static let pendingText: Color = Color(uiColor: UIColor(hex: "A79A2A"))
	static let approvedText: Color = Color(uiColor: UIColor(hex: "2BA72A"))
	static let declinedText: Color = Color(uiColor: UIColor(hex: "A72A2A"))
	static let completedText: Color = Color(uiColor: UIColor(hex: "858585"))
	
	static let pendingBackground: Color = Color(uiColor: UIColor(hex: "FCF7C9"))
	static let approvedBackground: Color = Color(uiColor: UIColor(hex: "F3FAF2"))
	static let declinedBackground: Color = Color(uiColor: UIColor(hex: "FAF2F2"))
	static let completedBackground: Color = Color(uiColor: UIColor(hex: "F8F8F8"))
	
	static let darkGreen: Color = Color(uiColor: UIColor(hex: "005620"))
}
