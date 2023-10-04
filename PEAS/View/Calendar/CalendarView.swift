//
//  CalendarView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct CalendarView: View {
	let yOffsetPadding: CGFloat = 200
	
	@StateObject var viewModel: ViewModel
	
	@State var yOffset: CGFloat
	
	init(viewModel: ViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
		self._yOffset = State(initialValue: SizeConstants.screenSize.height - yOffsetPadding)
	}
	
	var body: some View {
		NavigationStack(path: $viewModel.navStack) {
			ZStack {
				VerticalTabView(selection: $viewModel.selectedDateIndex, hasOffset: yOffset > 0) {
					ForEach(0..<viewModel.months.count, id: \.self) {
						monthsView(currentIndex: $0)
							.tag($0 / 2)
					}
					.tint(Color.clear)
					.opacity(viewModel.isExpanded ? 1.0 : 0.0)
					.animation(.easeInOut, value: viewModel.isExpanded)
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.background(Color.app.accent.edgesIgnoringSafeArea(.top))
				.offset(y: -yOffset)
				.animation(.linear.speed(2.0), value: yOffset)
				VStack(spacing: 0) {
					MonthView(
						month: viewModel.selectedDate,
						selectedDate: viewModel.selectedDate,
						isCollapsed: true,
						daysToHighlight: viewModel.daysWithOrders
					) { date in
						self.viewModel.dateSelected(date: date)
					}
					.padding(.bottom)
					.background(Color.app.accent.edgesIgnoringSafeArea(.top))
					ScrollView {
						LazyVStack {
							ForEach(viewModel.currentShowingOrders) { order in
								Button(action: { viewModel.pushStack(.order(order)) }) {
									OrderView(
										viewModel: OrderView.ViewModel(
											context: .calendar,
											business: viewModel.business,
											order: order
										)
									)
								}
								.buttonStyle(.plain)
								.padding(.bottom, 20)
							}
						}
						.padding(.top, 40)
						.padding(.bottom, SizeConstants.scrollViewBottomPadding)
					}
					Spacer(minLength: 0)
				}
				.opacity(viewModel.isExpanded ? 0.0 : 1.0)
				.animation(.linear.speed(4.0), value: viewModel.isExpanded)
			}
			.overlay(alignment: .topTrailing) {
				Button(action: {
					viewModel.setSelectedDateIndex()
					withAnimation(.default) {
						self.viewModel.isExpanded.toggle()
					}
				}) {
					Image(systemName: "chevron.down.circle.fill")
						.font(Font.app.largeTitle)
						.foregroundColor(Color.white)
						.rotationEffect(viewModel.isExpanded ? .degrees(180) : .degrees(0))
						.animation(.easeInOut, value: viewModel.isExpanded)
				}
				.padding(.trailing)
			}
			.navigationTitle("")
			.navigationDestination(for: ViewModel.Route.self) { route in
				Group {
					switch route {
					case .order(let order):
						OrderView(viewModel: OrderView.ViewModel(context: .detail, business: viewModel.business, order: order))
					}
				}
				.navigationBarTitleDisplayMode(.inline)
			}
			.onAppear { self.viewModel.didAppear() }
			.onChange(of: self.viewModel.selectedDate) { _ in
				self.viewModel.setSelectedDateIndex()
			}
			.onChange(of: viewModel.isExpanded) { _ in
				setYOffset()
			}
			.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
				self.viewModel.didAppear()
			}
		}
	}
	
	@ViewBuilder
	func monthsView(currentIndex: Int) -> some View {
		let nextIndex = currentIndex + 1
		if currentIndex % 2 == 0 || currentIndex == 0 {
			VStack {
				MonthView(
					month: viewModel.months[currentIndex],
					selectedDate: viewModel.selectedDate,
					daysToHighlight: viewModel.daysWithOrders
				) { date in
					viewModel.dateSelected(date: date)
				}
				Spacer()
				if nextIndex < viewModel.months.count {
					MonthView(
						month: viewModel.months[nextIndex],
						selectedDate: viewModel.selectedDate,
						daysToHighlight: viewModel.daysWithOrders
					) { date in
						viewModel.dateSelected(date: date)
					}
					Spacer()
				}
			}
		}
	}
	
	func setYOffset() {
		if viewModel.isExpanded {
			yOffset = 0
		} else {
			yOffset = SizeConstants.screenSize.height - yOffsetPadding
		}
	}
}

struct CalendarView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			CalendarView(viewModel: .init(business: Business.mock1, orders: [Order.mock1, Order.mock2, Order.mock3]))
		}
	}
}
