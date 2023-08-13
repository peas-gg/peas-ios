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
	
	var body: some View {
		VStack {
			if isExpanded {
				VerticalTabView {
					ForEach(0..<months.count, id: \.self) {
						monthsView(currentIndex: $0)
					}
					.tint(Color.clear)
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.background(Color.app.accent.edgesIgnoringSafeArea(.top))
			} else {
				VStack {
					MonthView(month: Date.now, selectedDate: Date.now, isCollapsed: true)
						.padding(.bottom)
						.background(Color.app.accent.edgesIgnoringSafeArea(.top))
					Spacer()
				}
			}
		}
		.overlay(alignment: .topTrailing) {
			Button(action: { self.isExpanded.toggle() }) {
				Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
					.font(Font.app.largeTitle)
					.foregroundColor(Color.white)
			}
			.padding(.trailing)
		}
	}
	
	@ViewBuilder
	func monthsView(currentIndex: Int) -> some View {
		Group {
			let count = months.count
			let nextIndex = currentIndex + 1
			if count == 1 {
				MonthView(month: months[currentIndex])
			} else if currentIndex % 2 == 0, nextIndex < count {
				VStack {
					MonthView(month: months[currentIndex])
					Spacer()
					MonthView(month: months[nextIndex])
					Spacer()
				}
			} else if currentIndex % 2 == 0, nextIndex >= count {
				VStack {
					MonthView(month: months[currentIndex])
					Spacer()
				}
			}
		}
	}
}

struct CalendarView_Previews: PreviewProvider {
	static var previews: some View {
		CalendarView(viewModel: .init())
	}
}
