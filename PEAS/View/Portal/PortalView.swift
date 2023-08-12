//
//  PortalView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct PortalView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Text("Hello, World!")
	}
}

struct PortalView_Previews: PreviewProvider {
	static var previews: some View {
		PortalView(viewModel: .init())
	}
}
