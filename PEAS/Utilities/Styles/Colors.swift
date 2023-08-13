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
	
	//Others
	static let primaryText: Color = Color.black
	static let secondaryText: Color = Color.white
	static let tertiaryText: Color = Color(uiColor: UIColor(hex: "A8A8A8"))
	
	static let darkGreen: Color = Color(uiColor: UIColor(hex: "005620"))
}
