//
//  DashboardView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct DashboardView: View {
	let filterMenuId: String = "FilterMenuId"
	
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		NavigationStack(path: $viewModel.navStack) {
			VStack {
				VStack(spacing: 20) {
					HStack {
						VStack (alignment: .leading){
							Text("Welcome,")
								.foregroundColor(Color.app.tertiaryText)
							Text(viewModel.user.firstName)
								.foregroundColor(Color.app.primaryText)
								.lineLimit(1)
						}
						.font(.system(size: FontSizes.title1, weight: .semibold, design: .rounded))
						Spacer(minLength: 0)
						Button(action: { viewModel.showUserView() }) {
							CachedAvatar(
								url: viewModel.business.profilePhoto,
								height: SizeConstants.avatarHeight + 10
							)
						}
					}
					.padding(.top, 30)
					Text("$2,378.56")
						.foregroundColor(Color.app.accent)
						.font(.system(size: 50, weight: .semibold, design: .rounded))
					HStack {
						Spacer()
						buttonView(symbol: "dollarsign.circle", title: "CashOut") {
							viewModel.cashOut()
						}
						Spacer()
							.frame(width: 20)
						buttonView(symbol: "doc.text", title: "Transactions") {
							
						}
						Spacer()
					}
				}
				.padding(.horizontal)
				.padding(.horizontal, 10)
				VStack {
					VStack {
						HStack {
							Text("Services (7 pending)")
								.font(Font.app.bodySemiBold)
							Spacer()
							if let selectedOrderFilter = viewModel.selectedOrderFilter {
								filterIndicator(filter: selectedOrderFilter)
							}
							Button(action: { viewModel.toggleFilterMenu() }) {
								Image(systemName: viewModel.selectedOrderFilter == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
							}
							.opacity(viewModel.isShowingFilterMenu ? 0.5 : 1.0)
							.anchorPreference(key: BoundsPreferenceKey.self, value: .bounds) { [filterMenuId : $0] }
						}
						Divider()
						ScrollView {
							LazyVStack {
								Button(action: { viewModel.pushStack(.order(Order.mock1)) }) {
									OrderView(viewModel: .init(context: .dashboard, order: Order.mock1))
								}
								Button(action: { viewModel.pushStack(.order(Order.mock1)) }) {
									OrderView(viewModel: .init(context: .dashboard, order: Order.mock1))
								}
								.buttonStyle(.plain)
							}
							.padding(.top, 10)
						}
					}
					.padding()
				}
				.background {
					Color.app.primaryBackground
						.cornerRadius(10, corners: [.topLeft, .topRight])
				}
				.edgesIgnoringSafeArea(.bottom)
				.padding(.horizontal, 10)
				.padding(.top)
				Spacer(minLength: 0)
			}
			.background(Color.app.secondaryBackground)
			.foregroundColor(Color.app.primaryText)
			.navigationTitle("")
			.navigationDestination(for: ViewModel.Route.self) { route in
				Group {
					switch route {
					case .order(let order):
						OrderView(viewModel: OrderView.ViewModel(context: .detail, order: order))
					}
				}
				.navigationBarTitleDisplayMode(.inline)
			}
		}
		.tint(Color.app.primaryText)
		.appMenu(id: filterMenuId, isShowing: $viewModel.isShowingFilterMenu) {
			VStack {
				ForEach(Order.Status.allCases) { status in
					Button(action: { viewModel.selectFilter(status) }) {
						HStack {
							Text(status.rawValue.capitalized)
								.font(Font.app.body)
							Spacer()
							filterIndicator(filter: status)
						}
					}
				}
			}
			.foregroundColor(Color.app.primaryText)
			.padding()
			.frame(width: 160)
		}
		.sheet(isPresented: $viewModel.isShowingUserView) {
			UserView(viewModel: UserView.ViewModel(user: viewModel.user))
		}
		.sheet(isPresented: $viewModel.isShowingCashOut) {
			CashOutView(
				viewModel: CashOutView.ViewModel(user: viewModel.user, context: .cashOut),
				onDismiss: { viewModel.setIsShowingCashOut(false) }
			)
		}
		.fullScreenCover(isPresented: $viewModel.isShowingCashOutOnboarding) {
			CashOutView(
				viewModel: CashOutView.ViewModel(user: viewModel.user, context: .onboarding),
				onDismiss: { viewModel.setIsShowingCashOutOnboarding(false) }
			)
		}
		.onAppear {
			viewModel.refresh()
		}
	}
	
	@ViewBuilder
	func buttonView(symbol: String, title: String, action: @escaping () -> ()) -> some View {
		Button(action: { action() }) {
			HStack {
				Image(systemName: symbol)
				Text(title)
			}
			.font(Font.app.bodySemiBold)
			.foregroundColor(Color.app.primaryText)
			.padding(10)
			.background {
				RoundedRectangle(cornerRadius: 10)
					.fill(Color.white)
			}
		}
	}
	
	@ViewBuilder
	func filterIndicator(filter: Order.Status) -> some View {
		ZStack {
			Circle()
				.fill(filter.backgroundColor)
			Circle()
				.stroke(filter.foregroundColor)
		}
		.frame(dimension: 15)
	}
}

struct DashboardView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			DashboardView(viewModel: .init(user: User.mock1, business: Business.mock1))
		}
	}
}
