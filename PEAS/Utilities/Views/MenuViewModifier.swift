//
//  MenuViewModifier.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-30.
//

import SwiftUI

struct MenuViewModifier<Menu: View>: ViewModifier {
	let parentRect: CGRect
	let topPadding: CGFloat
	@Binding var isShowing: Bool
	@ViewBuilder var menu: () -> Menu
	
	@State var rect: CGRect = .zero
	
	func body(content: Content) -> some View {
		content
			.overlay {
				if isShowing {
					Color.clear
						.contentShape(Rectangle())
						.onTapGesture {
							withAnimation {
								self.isShowing = false
							}
						}
						.overlay {
							menu()
								.background {
									ZStack {
										let cornerRadius: CGFloat = 10
										RoundedRectangle(cornerRadius: cornerRadius)
											.fill(Color.white)
										RoundedRectangle(cornerRadius: cornerRadius)
											.stroke(Color.gray, lineWidth: 2)
									}
								}
								.readSize {
									self.rect = $0
								}
								.position(x: parentRect.midX, y: parentRect.maxY)
								.offset(x: -(rect.width - parentRect.width) / 2, y: (rect.height - parentRect.height) / 2)
								.padding(.top, topPadding)
						}
						.transition(.opacity)
						.animation(.easeInOut, value: isShowing)
				}
			}
	}
}

fileprivate struct TestView: View {
	@State var isShowingMenu: Bool = false
	@State var menuButtonRect: CGRect = .zero
	
	var body: some View {
		VStack {
			Spacer()
			Spacer()
			HStack {
				Spacer()
				Button(action: {
					withAnimation(.default) {
						self.isShowingMenu.toggle()
					}
				}) {
					Text("@")
						.font(Font.app.title1)
						.foregroundColor(Color.white)
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 10)
								.fill(Color.white.opacity(0.5))
						)
						.readSize { self.menuButtonRect = $0 }
				}
				Spacer()
			}
			Text("Hi there")
			Spacer()
		}
		.menu(isShowing: $isShowingMenu, parentRect: menuButtonRect, topPadding: -20) {
			VStack {
				Button(action: {}) {
					Text("Tap me")
				}
				Button(action: {}) {
					Text("Tap me")
				}
				Button(action: {}) {
					Text("Tap me")
				}
				Button(action: {}) {
					Text("Tap me")
				}
				Button(action: {}) {
					Text("Tap me")
				}
				Button(action: {}) {
					HStack {
						Text("Tap me")
						Image(systemName: "line.3.horizontal.decrease.circle")
					}
				}
			}
			.padding()
			.padding()
			.foregroundColor(Color.black)
		}
	}
}

struct MenuViewModifier_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			TestView()
				.preferredColorScheme(.dark)
		}
	}
}
