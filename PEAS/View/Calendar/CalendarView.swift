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
	
	@State var isExpanded: Bool = false
	
	@State var selectedDate: Date = Date.now
	@State var selectedDateIndex: Int = 0
	
	var body: some View {
		VStack {
			if isExpanded {
				VerticalTabView(selection: $selectedDateIndex) {
					ForEach(0..<months.count, id: \.self) {
						monthsView(currentIndex: $0)
					}
					.tint(Color.clear)
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.background(Color.app.accent.edgesIgnoringSafeArea(.top))
				.transition(.identity)
			} else {
				VStack {
					MonthView(month: selectedDate, selectedDate: selectedDate, isCollapsed: true) { date in
						self.selectedDate = date
					}
					.padding(.bottom)
					.background(Color.app.accent.edgesIgnoringSafeArea(.top))
					Spacer()
				}
				.transition(.identity)
			}
		}
		.overlay(alignment: .topTrailing) {
			Button(action: {
				setSelectedDateIndex()
				withAnimation(.default) {
					self.isExpanded.toggle()
				}
			}) {
				Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
					.font(Font.app.largeTitle)
					.foregroundColor(Color.white)
			}
			.padding(.trailing)
		}
		.onAppear { self.setSelectedDateIndex() }
		.onChange(of: self.selectedDate) { _ in
			self.setSelectedDateIndex()
		}
	}
	
	@ViewBuilder
	func monthsView(currentIndex: Int) -> some View {
		Group {
			let count = months.count
			let nextIndex = currentIndex + 1
			if count == 1 {
				MonthView(month: months[currentIndex], selectedDate: selectedDate) { date in
					dateSelected(date: date)
				}
			} else if currentIndex % 2 == 0, nextIndex < count {
				VStack {
					MonthView(month: months[currentIndex], selectedDate: selectedDate) { date in
						dateSelected(date: date)
					}
					Spacer()
					MonthView(month: months[nextIndex], selectedDate: selectedDate) { date in
						dateSelected(date: date)
					}
					Spacer()
				}
			} else if currentIndex % 2 == 0, nextIndex >= count {
				VStack {
					MonthView(month: months[currentIndex], selectedDate: selectedDate) { date in
						dateSelected(date: date)
					}
					Spacer()
				}
			}
		}
	}
	
	func setSelectedDateIndex() {
		let month: Date = selectedDate.startOfMonth()
		let adjuster = (months.firstIndex(of: month) ?? 0) / 2
		if adjuster % 2 > 0 {
			self.selectedDateIndex = adjuster + 3
		} else {
			self.selectedDateIndex = adjuster
		}
	}
	
	func dateSelected(date: Date) {
		self.selectedDate = date
		withAnimation(.default) {
			self.isExpanded.toggle()
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
