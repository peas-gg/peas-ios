//
//  PEASApp.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

@main
struct PEASApp: App {
	var body: some Scene {
		WindowGroup {
			AppView()
				.onAppear {
					if let keyWindow = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) {
						keyWindow.overrideUserInterfaceStyle = .light
					}
				}
		}
	}
}
