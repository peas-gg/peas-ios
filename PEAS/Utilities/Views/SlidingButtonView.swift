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
	
	enum Status {
		case inProgress
		case success
		case unknown
	}
	
	@Binding var status: Status
	
	@State var xOffset: CGFloat
	@State var width: CGFloat = .zero
	
	@State var maxXDistance: CGFloat = .zero
	
	var didComplete: () -> ()
	
	//Clients
	let feedbackClient: FeedbackClient = FeedbackClient.shared
	
	init(status: Binding<Status>, didComplete: @escaping () ->() = {}) {
		self._status = status
		self._xOffset = State(initialValue: baseOffset)
		self.didComplete = didComplete
	}
	
	var body: some View {
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
					switch status {
					case .inProgress:
						LoadingIndicator(lineWidth: 4)
							.frame(dimension: 30)
					case .success, .unknown:
						Image(systemName: status == .success ? "checkmark" : "arrow.right")
							.font(.system(size: 26, weight: .bold))
							.foregroundColor(Color.white)
					}
				}
				.frame(dimension: buttonDimension)
				.offset(x: xOffset)
				.onAppear { self.maxXDistance = getMaxDistance(width: width) }
			}
			.frame(width: width, height: proxy.size.height, alignment: .leading)
			.gesture(
				DragGesture()
					.onChanged { value in
						let maxXDistance = getMaxDistance(width: width)
						if (baseOffset..<maxXDistance).contains(value.translation.width) {
							self.xOffset = value.translation.width
							self.maxXDistance = maxXDistance
						}
					}
					.onEnded { _ in
						if self.xOffset < (getMaxDistance(width: width) - baseOffset) {
							self.xOffset = baseOffset
						} else {
							didComplete()
							self.feedbackClient.medium()
						}
					}
			)
		}
		.frame(height: height)
		.animation(.spring(), value: xOffset)
		.background {
			Capsule()
				.fill(Color.app.darkGreen)
				.overlay {
					let opacity: CGFloat = {
						return 1 - (xOffset / maxXDistance) - 0.2
					}()
					ShimmerTextView("Slide to cash out", font: Font.app.title3, color: Color.app.secondaryText)
						.opacity(opacity)
				}
		}
		.onChange(of: self.status) { newStatus in
			switch newStatus {
			case .inProgress, .success:
				return
			case .unknown:
				self.xOffset = baseOffset
			}
		}
	}
	
	func getMaxDistance(width: CGFloat) -> CGFloat {
		return width - buttonDimension - baseOffset
	}
}

struct SlidingButtonView_Previews: PreviewProvider {
	static var previews: some View {
		SlidingButtonView(status: Binding.constant(.unknown))
	}
}
