//
//  PulseView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-30.
//

import SwiftUI

struct PulseView: View {
	let size: CGFloat
	let circles: [CGFloat] = [1.0, 2.0, 3.0, 4.0]
	
	let timer = Timer.publish(every: 0.30, on: .main, in: .common).autoconnect()
	
	let isActive: Bool
	@State var currentCircle: CGFloat
	
	init(size: CGFloat, isActive: Bool) {
		self.size = size
		self.isActive = isActive
		self._currentCircle = State(initialValue: circles.first!)
	}
	
	var body: some View {
		ZStack {
			ForEach(circles, id: \.self) { circle in
				let factor: CGFloat = circle / circles.last!
				let dimension: CGFloat = size * factor
				let opacity: CGFloat = factor == 1.0 ? 0.1 : (1.0 - factor - 0.05)
				let colors: [Color] = {
					if isActive {
						return [Color.app.accent.opacity(0.2), Color.app.accent.opacity(opacity)]
					} else {
						return [Color.gray.opacity(0.2), Color.gray.opacity(opacity)]
					}
				}()
				Circle()
					.fill(
						RadialGradient(
							colors: colors,
							center: .center,
							startRadius: 0,
							endRadius: 180
						)
					)
					.frame(dimension: dimension)
					.opacity(circle <= currentCircle ? 1.0 : 0.0)
					.animation(.linear, value: currentCircle)
			}
		}
		.onReceive(timer) { _ in
			step()
		}
	}
	
	func step() {
		if isActive {
			if currentCircle < circles.last! {
				self.currentCircle += 1.0
			} else {
				self.currentCircle = circles.first!
			}
		} else {
			self.currentCircle = circles.last!
		}
	}
}

struct PulseView_Previews: PreviewProvider {
	static var previews: some View {
		PulseView(size: 240, isActive: true)
	}
}
