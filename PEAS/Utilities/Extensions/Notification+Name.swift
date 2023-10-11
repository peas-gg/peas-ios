//
//  Notification+Name.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-30.
//

import Foundation

extension Notification.Name {
	static let updateAppState = Notification.Name("updateAppState")
	static let refreshApp = Notification.Name("refreshApp")
	static let refreshOrders = Notification.Name("refreshOrder")
	static let refreshWallet = Notification.Name("refreshWallet")
}
