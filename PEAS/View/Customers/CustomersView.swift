//
//  CustomersView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct CustomersView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Text("Hello, World!")
	}
}

struct CustomersView_Previews: PreviewProvider {
	static var previews: some View {
		CustomersView(viewModel: .init())
	}
}
