//
//  CashOutView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-24.
//

import SwiftUI

struct CashOutView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		switch viewModel.context {
		case .onboarding:
			VStack {
				
			}
		case .cashOut:
			EmptyView()
		}
	}
}

struct CashOutView_Previews: PreviewProvider {
	static var previews: some View {
		CashOutView(viewModel: .init(context: .onboarding))
	}
}
