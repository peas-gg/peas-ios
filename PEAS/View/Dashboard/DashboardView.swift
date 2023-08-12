//
//  DashboardView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct DashboardView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Text("Hello, World!")
	}
}

struct DashboardView_Previews: PreviewProvider {
	static var previews: some View {
		DashboardView(viewModel: .init())
	}
}
