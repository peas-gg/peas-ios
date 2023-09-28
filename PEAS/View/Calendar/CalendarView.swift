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
			
			VStack {
				MonthView(month: viewModel.selectedDate, selectedDate: viewModel.selectedDate, isCollapsed: true) { date in
					self.viewModel.selectedDate = date
				}
				.padding(.bottom)
				.background(Color.app.accent.edgesIgnoringSafeArea(.top))
				Spacer()
			}
			.opacity(viewModel.isExpanded ? 0.0 : 1.0)
			.animation(.linear.speed(4.0), value: viewModel.isExpanded)
		}
		.overlay(alignment: .topTrailing) {
			Button(action: {
				setSelectedDateIndex()
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
		.onAppear { self.setSelectedDateIndex() }
		.onChange(of: self.viewModel.selectedDate) { _ in
			self.setSelectedDateIndex()
		}
		.onChange(of: viewModel.isExpanded) { _ in
			setYOffset()
		}
	}
	
	@ViewBuilder
	func monthsView(currentIndex: Int) -> some View {
		let nextIndex = currentIndex + 1
		if currentIndex % 2 == 0 || currentIndex == 0 {
			VStack {
				MonthView(month: viewModel.months[currentIndex], selectedDate: viewModel.selectedDate) { date in
					dateSelected(date: date)
				}
				Spacer()
				if nextIndex < viewModel.months.count {
					MonthView(month: viewModel.months[nextIndex], selectedDate: viewModel.selectedDate) { date in
						dateSelected(date: date)
					}
					Spacer()
				}
			}
		}
	}
	
	func setSelectedDateIndex() {
		let month: Date = viewModel.selectedDate.startOfMonth()
		let index = (viewModel.months.firstIndex(of: month) ?? 0)
		self.viewModel.selectedDateIndex = index / 2
	}
	
	func dateSelected(date: Date) {
		self.viewModel.selectedDate = date
		withAnimation(.default) {
			self.viewModel.isExpanded.toggle()
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
			CalendarView(viewModel: .init())
		}
	}
}
