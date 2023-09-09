//
//  AppMenuModifier.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-30.
//

import SwiftUI

struct AppMenuModifier<Menu: View>: ViewModifier {
	let id: String
	let screenRect: CGRect = UIScreen.main.bounds
	
	@Binding var isShowing: Bool
	@ViewBuilder let menu: () -> Menu
	
	@State var isShowingMenu: Bool = false
	@State var rect: CGRect = CGRect.zero
	
	func body(content: Content) -> some View {
		content
			.overlay(isShown: isShowingMenu) {
				Color.clear
					.contentShape(Rectangle())
					.onTapGesture {
						withAnimation(.default) {
							self.isShowing = false
						}
					}
			}
			.overlayPreferenceValue(BoundsPreferenceKey.self) { preferenceValues in
				if isShowingMenu {
					GeometryReader { geometry in
						if let parentAnchor: Anchor<CGRect> = preferenceValues[id] {
							menu()
								.readRect {
									self.rect = $0
								}
								.background {
									ZStack {
										let cornerRadius: CGFloat = SizeConstants.textCornerRadius
										RoundedRectangle(cornerRadius: cornerRadius)
											.fill(Color.white)
										RoundedRectangle(cornerRadius: cornerRadius)
											.stroke(Color.app.tertiaryText.opacity(0.5))
									}
								}
								.offset(
									x: getXOffset(parent: geometry[parentAnchor]),
									y: geometry[parentAnchor].maxY + 10
								)
						}
					}
					.transition(.asymmetric(insertion: .identity, removal: .scale))
					.animation(.easeOut, value: isShowingMenu)
				}
			}
			.onChange(of: self.isShowing) { isShowing in
				withAnimation(.default) {
					self.isShowingMenu = isShowing
				}
			}
	}
	
	func getXOffset(parent: CGRect) -> CGFloat {
		//Figure out where there is more space. (Right or Left)
		let rightSpace: CGFloat = screenRect.maxX - parent.minX
		let leftSpace: CGFloat = parent.maxX - screenRect.minX
		
		if rightSpace > leftSpace {
			return parent.minX
		} else {
			return parent.maxX - rect.width
		}
	}
}

fileprivate struct TestView: View {
	let menuId: String = "testView"
	@State var isShowingMenu: Bool = false
	
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
				}
				.anchorPreference(key: BoundsPreferenceKey.self, value: .bounds) { [menuId: $0] }
				Spacer()
			}
			Spacer()
		}
		.background(Color.black)
		.appMenu(
			id: menuId,
			isShowing: $isShowingMenu,
			menu: {
				VStack {
					HStack {
						Spacer()
						Button(action: {}) {
							Text("Tap me")
						}
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
				.frame(width: 200)
			}
		)
	}
}

struct AppMenuModifier_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			TestView()
				.preferredColorScheme(.dark)
		}
	}
}
