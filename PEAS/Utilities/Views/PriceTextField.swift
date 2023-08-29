//
//  PriceTextField.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-28.
//

import SwiftUI

struct PriceTextField: View {
	let priceFormatter: NumberFormatter =  {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}()
	
	@Binding var isFocused: Bool
	@Binding var priceText: String
	
	@FocusState var focusState: Bool
	
	@State var isShowingCursor: Bool = false
	
	var body: some View {
		ZStack(alignment: .leading) {
			let value: Double = 0.01 * Double(Int(priceText) ?? 0)
			Text("\(priceFormatter.string(for: value) ?? "")")
				.overlay(alignment: .bottomTrailing) {
					Rectangle()
						.frame(width: 10, height: 1, alignment: .trailing)
						.opacity(isShowingCursor && isFocused ? 1.0 : 0.0)
						.animation(.easeOut.speed(0.75).repeatForever(), value: isShowingCursor)
				}
			TextField("", text: $priceText)
				.keyboardType(.numberPad)
				.focused($focusState)
				.opacity(0)
		}
		.onChange(of: isFocused) { isFocused in
			self.focusState = isFocused
			self.isShowingCursor = isFocused
		}
		.onAppear {
			self.focusState = isFocused
			self.isShowingCursor = isFocused
		}
	}
}

struct PriceTextField_Previews: PreviewProvider {
	static var previews: some View {
		PriceTextField(isFocused: Binding.constant(false), priceText: Binding.constant("25"))
	}
}
