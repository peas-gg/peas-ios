//
//  HomeView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-24.
//

import SwiftUI

struct HomeView: View {
	@StateObject var viewModel: ViewModel
	
	//Clients
	@StateObject var appState: AppState = AppState.shared
	
	init(viewModel: ViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}
	
	var body: some View {
		TabView {
			DashboardView(viewModel: DashboardView.ViewModel(user: viewModel.user, business: viewModel.business))
				.tabItem {
					Label("Dashboard", systemImage: "tray.full.fill")
				}
			CalendarView(viewModel: CalendarView.ViewModel())
				.tabItem {
					Label("Calendar", systemImage: "calendar")
				}
			CustomersView(viewModel: CustomersView.ViewModel(business: viewModel.business))
				.tabItem {
					Label("Customers", systemImage: "person.text.rectangle")
						.environment(\.symbolVariants, .none)
				}
			SiteView(viewModel: SiteView.ViewModel(isTemplate: false, business: viewModel.business))
				.tabItem {
					Label("Site", systemImage: "globe")
				}
		}
		.tint(Color.black)
		.banner(data: $viewModel.bannerData)
		.fullScreenContainer(
			isShowing: Binding(
				get: { appState.requestPaymentVM != nil },
				set: { isShowing in
					if !isShowing {
						appState.setRequestPaymentVM(nil)
					}
				}
			)
		) {
			RequestPaymentView(viewModel: appState.safeRequestPaymentVM)
				.overlay {
					/**
					 We need this because for some reason, when the full screen container is in a TabView,
					 it does not dismiss correctly. (NOT SURE WHY THIS FIXES IT BUT IT DOES.)
					 (PLEASE DO NOT REMOVE)
					 */
					Button(action: {}) {
						Text("Weird button")
					}
					.buttonStyle(.borderedProminent)
					.opacity(0.0001)
				}
		}
		.onAppear {
			self.viewModel.refreshBusiness()
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(viewModel: .init(user: User.mock1, business: Business.mock1))
	}
}
