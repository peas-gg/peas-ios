//
//  KeyboardClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-05.
//

import Foundation
import UIKit

@MainActor class KeyboardClient: ObservableObject {
	static let shared: KeyboardClient = KeyboardClient()
	
	@Published var height: CGFloat = 0
	
	init() {
	}
	
	func resignKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
