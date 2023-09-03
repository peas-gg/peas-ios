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
		VStack {
			Spacer()
			Button(action: {}) {
				Text("Next")
			}
			.buttonStyle(.expanded(style: .white))
			.padding()
		}
		.background(Color.black)
	}
}

struct AuthenticateView_Previews: PreviewProvider {
	static var previews: some View {
		AuthenticateView(viewModel: .init())
	}
}
