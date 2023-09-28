//
//  CalendarVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import Foundation

extension CalendarView {
	@MainActor class ViewModel: ObservableObject {
		
		let months: [Date] = CalendarClient.shared.months
		
		@Published var isExpanded: Bool = false
		
		@Published var selectedDate: Date = Date.now
		@Published var selectedDateIndex: Int = 0
	}
}
