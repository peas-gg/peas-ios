//
//  BannerViewModifier.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-05.
//
import SwiftUI

struct BannerViewModifier: ViewModifier {
	let cornerRadius: CGFloat = 20
	
	@Binding var data: BannerData?
	
	@State var isShowing: Bool = false
	
	func body(content: Content) -> some View {
		content
			.overlay(
				Color.clear
					.onChange(of: self.data) { data in
						if data != nil {
							self.showBanner()
						} else {
							self.dismissBanner()
						}
					}
					.safeAreaInset(edge: .top) {
						if let data = data {
							if isShowing {
								HStack {
									Image(systemName: "info.circle.fill")
										.font(Font.app.title2)
									Text(data.detail)
										.font(Font.app.body)
										.foregroundColor(Color.app.primaryText)
								}
								.padding()
								.background {
									ZStack {
										RoundedRectangle(cornerRadius: self.cornerRadius)
											.fill(.thinMaterial)
										RoundedRectangle(cornerRadius: self.cornerRadius)
											.stroke(Color.white, lineWidth: 1)
									}
								}
								.padding(.horizontal)
								.offset(y: 60)
								.scaleEffect(isShowing ? 1.0 : 0.0, anchor: .center)
								.transition(.scale)
								.gesture(
									DragGesture(minimumDistance: 10)
										.onEnded { _ in
											self.dismissBanner()
										}
								)
								.onAppear {
									DispatchQueue.main.asyncAfter(deadline: .now() + data.timeOut) {
										self.dismissBanner()
									}
								}
							}
						}
					}
			)
	}
	
	private func showBanner() {
		withAnimation(.easeInOut) {
			self.isShowing = true
		}
	}
	
	private func dismissBanner() {
		withAnimation(.easeInOut) {
			self.data = nil
			self.isShowing = false
		}
	}
}

fileprivate struct BannerTestView: View {
	@State var banner: BannerData?
	
	var body: some View {
		VStack {
			Spacer()
			HStack {
				Spacer()
				Button(action: {
					self.banner = BannerData(detail: "The request was not accepted. Please try again. This is the very first time I am hearing about this you dweeb")
				}) {
					Text("This is the Banner View")
						.foregroundColor(.white)
				}
				Spacer()
			}
			Spacer()
		}
		.background(Color.black)
		.banner(data: $banner)
	}
}

struct BannerView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			BannerTestView()
		}
	}
}
