//
//  CalendarView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct CalendarView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Text("Hello, World!")
	}
}

struct CalendarView_Previews: PreviewProvider {
	static var previews: some View {
		CalendarView(viewModel: .init())
	}
}
