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
	
	var body: some View {
		VerticalTabView {
			ForEach(0..<months.count, id: \.self) {
				monthView(currentIndex: $0)
			}
		}
		.background(Color.accentColor)
		.tabViewStyle(.page(indexDisplayMode: .never))
	}
	
	@ViewBuilder
	func monthView(currentIndex: Int) -> some View {
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
