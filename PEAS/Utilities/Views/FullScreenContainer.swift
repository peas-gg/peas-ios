//
//  FullScreenContainer.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-12.
//
import SwiftUI

struct FullScreenContainer<Content: View>: View {
	enum SwipeDirection {
		case up, down
	}
	
	let size: CGSize = UIScreen.main.bounds.size
	
	let appearAnimation: Animation = .interactiveSpring().speed(0.30)
	let swipeAnimation: Animation = .linear
	
	@Binding var isShowing: Bool
	@ViewBuilder var content: () -> Content
	
	@State var yOffset: CGFloat = UIScreen.main.bounds.size.height
	
	var body: some View {
		content()
			.offset(x: 0, y: yOffset)
			.onChange(of: isShowing) { isShowing in
				if isShowing {
					withAnimation(appearAnimation) {
						self.yOffset = 0
					}
				} else {
					withAnimation(appearAnimation) {
						self.yOffset = size.height
					}
				}
			}
			.gesture(
				DragGesture(minimumDistance: 10)
					.onChanged { value in
						let distanceTravelled = value.translation.height
						switch getSwipeDirection(value.startLocation.y, value.location.y) {
						case .up:
							if yOffset == 0 || distanceTravelled < 0 {
								return
							} else {
								withAnimation(swipeAnimation) {
									self.yOffset -= distanceTravelled
								}
							}
						case .down:
							withAnimation(swipeAnimation) {
								self.yOffset = distanceTravelled
							}
						}
					}
					.onEnded { value in
						let distanceTravelled = value.translation.height
						switch getSwipeDirection(value.startLocation.y, value.location.y) {
						case .up:
							withAnimation(swipeAnimation) {
								self.yOffset = 0
							}
						case .down:
							if distanceTravelled > 100 {
								withAnimation(appearAnimation) {
									self.yOffset = size.height
									self.isShowing = false
								}
							} else {
								withAnimation(swipeAnimation) {
									self.yOffset = 0
								}
							}
						}
					}
			)
	}
	
	func getSwipeDirection(_ startYLocation: CGFloat, _ endYLocation: CGFloat) -> SwipeDirection {
		if startYLocation < endYLocation {
			return .down
		} else {
			return .up
		}
	}
}

fileprivate struct TestView: View {
	@State var isShowingFullScreen: Bool = false
	
	var body: some View {
		VStack {
			Button(action: { isShowingFullScreen = true }) {
				Text("Tap Me Please")
					.padding()
					.background(Color.black, in: Capsule())
			}
		}
		.overlay {
			FullScreenContainer(isShowing: $isShowingFullScreen) {
				Color.green.ignoresSafeArea()
					.overlay {
						Button(action: { self.isShowingFullScreen.toggle() }) {
							Text("Dismiss")
								.foregroundColor(.blue)
						}
					}
			}
		}
	}
}

struct FullScreenContainer_Previews: PreviewProvider {
	static var previews: some View {
		TestView()
	}
}
