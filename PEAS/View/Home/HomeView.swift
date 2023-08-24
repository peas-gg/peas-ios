//
//  HomeView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-24.
//

import SwiftUI

struct HomeView: View {
	@StateObject var viewModel: ViewModel
	
	init(viewModel: ViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}
	
	var body: some View {
		TabView {
			DashboardView(viewModel: DashboardView.ViewModel())
				.tabItem {
					Label("Dashboard", systemImage: "tray.full.fill")
				}
			CalendarView(viewModel: CalendarView.ViewModel())
				.tabItem {
					Label("Calendar", systemImage: "calendar")
				}
			PortalView(viewModel: PortalView.ViewModel(isTemplate: true, business: Business.mock1))
				.tabItem {
					Label("Portal", systemImage: "globe")
				}
			CustomersView(viewModel: CustomersView.ViewModel())
				.tabItem {
					Label("Customers", systemImage: "person.text.rectangle")
						.environment(\.symbolVariants, .none)
				}
		}
		.tint(Color.black)
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(viewModel: .init())
	}
}
