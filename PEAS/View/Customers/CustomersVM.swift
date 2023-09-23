//
//  CustomersVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import IdentifiedCollections
import Foundation

extension CustomersView {
	@MainActor class ViewModel: ObservableObject {
		@Published var customers: IdentifiedArrayOf<Customer>
		
		init(customers: IdentifiedArrayOf<Customer> = []) {
			self.customers = customers
		}
	}
}
