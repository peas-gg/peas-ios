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
	let appState: AppState = AppState.shared
	
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
			CustomersView(viewModel: CustomersView.ViewModel())
				.tabItem {
					Label("Customers", systemImage: "person.text.rectangle")
						.environment(\.symbolVariants, .none)
				}
			SiteView(viewModel: viewModel.siteVM)
				.tabItem {
					Label("Site", systemImage: "globe")
				}
		}
		.tint(Color.black)
		.fullScreenContainer(
			isShowing: Binding(
				get: { appState.isShowingRequestPayment },
				set: { appState.setIsShowingPaymentView($0) }
			)
		) {
			RequestPaymentView(viewModel: .init())
		}
		.banner(data: $viewModel.bannerData)
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
