//
//  AuthenticateView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import SwiftUI

struct AuthenticateView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Text("Hello, World!")
	}
}

struct AuthenticateView_Previews: PreviewProvider {
	static var previews: some View {
		AuthenticateView(viewModel: .init())
	}
}
