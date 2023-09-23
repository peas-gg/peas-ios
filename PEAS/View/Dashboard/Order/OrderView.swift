//
//  OrderView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import SwiftUI

struct OrderView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Text("Hello, World!")
	}
}

struct OrderView_Previews: PreviewProvider {
	static var previews: some View {
		OrderView(viewModel: .init(context: .detail, order: Order.mock1))
	}
}
