//
//  CalendarView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct CalendarView: View {
	@StateObject var viewModel: ViewModel
	
	let months: [Date] = CalendarClient.shared.months
	let yOffsetPadding: CGFloat = 200
	
	@State var isExpanded: Bool = false
	
	@State var selectedDate: Date = Date.now
	@State var selectedDateIndex: Int = 0
	
	@State var yOffset: CGFloat
	
	init(viewModel: ViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
		self._yOffset = State(initialValue: SizeConstants.screenSize.height - yOffsetPadding)
	}
	
	var body: some View {
		ZStack {
			VerticalTabView(selection: $selectedDateIndex, hasOffset: yOffset > 0) {
				ForEach(0..<months.count, id: \.self) {
					monthsView(currentIndex: $0)
						.tag($0 / 2)
				}
				.tint(Color.clear)
				.opacity(isExpanded ? 1.0 : 0.0)
				.animation(.easeInOut, value: isExpanded)
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
			.background(Color.app.accent.edgesIgnoringSafeArea(.top))
			.offset(y: -yOffset)
			.animation(.linear.speed(2.0), value: yOffset)
			
			VStack {
				MonthView(month: selectedDate, selectedDate: selectedDate, isCollapsed: true) { date in
					self.selectedDate = date
				}
				.padding(.bottom)
				.background(Color.app.accent.edgesIgnoringSafeArea(.top))
				Spacer()
			}
			.opacity(isExpanded ? 0.0 : 1.0)
			.animation(.linear.speed(4.0), value: isExpanded)
			
			VStack {
				Spacer()
				Button(action: { AppState.shared.setIsShowingPaymentView(true) }) {
					Text("Request Payment")
				}
				.buttonStyle(.expanded(style: .green))
				.padding(.bottom)
			}
		}
		.overlay(alignment: .topTrailing) {
			Button(action: {
				setSelectedDateIndex()
				withAnimation(.default) {
					self.isExpanded.toggle()
				}
			}) {
				Image(systemName: "chevron.down.circle.fill")
					.font(Font.app.largeTitle)
					.foregroundColor(Color.white)
					.rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
					.animation(.easeInOut, value: isExpanded)
			}
			.padding(.trailing)
		}
		.onAppear { self.setSelectedDateIndex() }
		.onChange(of: self.selectedDate) { _ in
			self.setSelectedDateIndex()
		}
		.onChange(of: isExpanded) { _ in
			setYOffset()
		}
	}
	
	@ViewBuilder
	func monthsView(currentIndex: Int) -> some View {
		let nextIndex = currentIndex + 1
		if currentIndex % 2 == 0 || currentIndex == 0 {
			VStack {
				MonthView(month: months[currentIndex], selectedDate: selectedDate) { date in
					dateSelected(date: date)
				}
				Spacer()
				if nextIndex < months.count {
					MonthView(month: months[nextIndex], selectedDate: selectedDate) { date in
						dateSelected(date: date)
					}
					Spacer()
				}
			}
		}
	}
	
	func setSelectedDateIndex() {
		let month: Date = selectedDate.startOfMonth()
		let index = (months.firstIndex(of: month) ?? 0)
		self.selectedDateIndex = index / 2
	}
	
	func dateSelected(date: Date) {
		self.selectedDate = date
		withAnimation(.default) {
			self.isExpanded.toggle()
		}
	}
	
	func setYOffset() {
		if isExpanded {
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
