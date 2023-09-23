//
//  StepperView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-29.
//

import SwiftUI

struct StepperView: View {
	let min: Int
	let max: Int
	let step: Int
	
	@Binding var value: Int
	
	//Clients
	let feedbackClient: FeedbackClient = FeedbackClient.shared
	
	var body: some View {
		HStack(spacing: 10) {
			Button(action: { decrement() }) {
				container(name: "minus")
			}
			.buttonStyle(.insideScaling)
			.disabled(value <= min)
			
			Button(action: { increment() }) {
				container(name: "plus")
			}
			.buttonStyle(.outsideScaling)
			.disabled(value >= max)
		}
	}
	
	@ViewBuilder
	func container(name: String) -> some View {
		CardBackground()
			.frame(dimension: 46)
			.overlay(
				Image(systemName: name)
					.font(.system(size: FontSizes.body, weight: .heavy, design: .rounded))
					.foregroundColor(Color.black)
			)
	}
	
	func increment() {
		let newValue = value + step
		if newValue > max {
			value = max
		} else {
			value = newValue
		}
		feedbackClient.light()
	}
	
	func decrement() {
		let newValue = value - step
		if newValue < min {
			value = min
		} else {
			value = newValue
		}
		feedbackClient.light()
	}
}

fileprivate struct TestView: View {
	@State var value: Int = 0
	
	var body: some View {
		HStack {
			Text("\(value)")
			Spacer()
			StepperView(min: 0, max: 86400, step: 300, value: $value)
		}
		.padding(.horizontal)
	}
}

struct StepperView_Previews: PreviewProvider {
	static var previews: some View {
		TestView()
	}
}
