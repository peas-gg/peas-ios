//
//  AppView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct AppView: View {
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

struct AppView_Previews: PreviewProvider {
	static var previews: some View {
		AppView()
	}
}
