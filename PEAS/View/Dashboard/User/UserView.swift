//
//  UserView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-11.
//

import SwiftUI

struct UserView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Text("Hello, World!")
	}
}

struct UserView_Previews: PreviewProvider {
	static var previews: some View {
		UserView(viewModel: .init())
	}
}
