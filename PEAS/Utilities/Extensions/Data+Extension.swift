//
//  Data+Extension.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-02.
//

import Foundation

extension Data {
	var hexString: String {
		return map({ String(format: "%02x", $0) }).joined()
	}
}
