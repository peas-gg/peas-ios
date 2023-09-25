//
//  SlidingButtonView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-24.
//

import SwiftUI

struct SlidingButtonView: View {
	let height: CGFloat = 70
	let baseOffset: CGFloat = 6
	let buttonDimension: CGFloat = 60
	
	@State var xOffset: CGFloat
	@State var width: CGFloat = .zero
	
	@State var didComplete: Bool = false
	
	var maxXDistance: CGFloat {
		width - buttonDimension - baseOffset
	}
	
	//Clients
	let feedbackClient: FeedbackClient = FeedbackClient.shared
	
	init() {
		self._xOffset = State(initialValue: baseOffset)
	}
	
	var body: some View {
		HStack {
			GeometryReader { proxy in
				let width: CGFloat = proxy.frame(in: .local).width
				HStack {
					ZStack {
						Circle()
							.fill(Color.app.accent)
						Circle()
							.stroke(
								LinearGradient(
									colors: [Color.clear, Color.white.opacity(0.5), Color.white],
									startPoint: .leading,
									endPoint: .trailing
								)
							)
						Image(systemName: didComplete ? "checkmark" : "arrow.right")
							.font(.system(size: 26, weight: .bold))
							.foregroundColor(Color.white)
					}
					.frame(dimension: buttonDimension)
					.offset(x: xOffset)
				}
				.frame(width: width, height: proxy.size.height, alignment: .leading)
				.onAppear { self.width = width }
				.gesture(
					DragGesture()
						.onChanged { value in
							if (baseOffset..<maxXDistance).contains(value.translation.width) {
								self.xOffset = value.translation.width
							}
						}
						.onEnded { _ in
							if self.xOffset < (maxXDistance - baseOffset) {
								self.xOffset = baseOffset
							} else {
								self.didComplete = true
								self.feedbackClient.medium()
							}
						}
				)
			}
			.frame(height: height)
			.animation(.spring(), value: xOffset)
		}
		.background {
			Capsule()
				.fill(Color.app.darkGreen)
				.overlay {
					let opacity: CGFloat = {
						return 1 - (xOffset / maxXDistance) - 0.2
					}()
					ZStack {
						Text("Slide to cash out")
							.font(Font.app.title3)
							.foregroundColor(Color.app.secondaryText.opacity(opacity))
					}
				}
		}
	}
}

struct SlidingButtonView_Previews: PreviewProvider {
	static var previews: some View {
		SlidingButtonView()
	}
}
