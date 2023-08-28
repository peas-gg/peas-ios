//
//  CachedImage.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-22.
//

import SwiftUI

struct CachedImage<Content: View, PlaceHolder: View>: View {
	let url: URL
	
	@ViewBuilder let content: (UIImage) -> Content
	@ViewBuilder let placeHolder: () -> PlaceHolder
	
	@State var image: UIImage?
	@State var isLoadingImage: Bool = true
	
	//Clients
	let apiClient: APIClient = APIClient.shared
	let cacheClient: CacheClient = CacheClient.shared
	
	init(
		url: URL,
		@ViewBuilder content: @escaping (UIImage) -> Content,
		@ViewBuilder placeHolder: @escaping () -> PlaceHolder
	) {
		self.url = url
		self.content = content
		self.placeHolder = placeHolder
	}
	
	var body: some View {
		Group {
			if let uiImage = image {
				content(uiImage)
			} else {
				placeHolder()
					.overlay(isShown: isLoadingImage) {
						ProgressView()
					}
			}
		}
		.onChange(of: url) { _ in
			image = nil
			loadImage()
		}
		.onAppear {
			loadImage()
		}
	}
	
	func loadImage() {
		Task {
			guard image == nil else { return }
			if let image = await cacheClient.getImage(url: url) {
				self.image = image
				self.isLoadingImage = false
				return
			}
			self.image = await apiClient.getImage(url: url)
			self.isLoadingImage = false
			if let image = self.image {
				await cacheClient.setImage(url: url, image: image)
			}
		}
	}
}

struct CachedImage_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			CachedImage(
				url: URL(string: "https://kingsleyokeke.blob.core.windows.net/images/1597276037537.jpeg")!,
				content: { uiImage in
					Image(uiImage: uiImage)
						.resizable()
						.aspectRatio(contentMode: .fit)
				},
				placeHolder: {
					Color.red
				}
			)
			.clipShape(Circle())
			.frame(dimension: 200)
		}
	}
}
