//
//  PermissionClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-06.
//

import Foundation
import UIKit

@frozen enum PermissionState {
	case undetermined, allowed, denied
}

class PermissionClient: ObservableObject {
	static let shared: PermissionClient = PermissionClient()
	
	init() {
		
	}
	
	func openSystemSettings() {
		DispatchQueue.main.async {
			Task {
				await UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
			}
		}
	}
}
