//
//  ViewModel.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-30.
//

import Combine
import Foundation
import IdentifiedCollections
import SwiftUI

extension SiteOnboardingView {
	@MainActor class ViewModel: ObservableObject {
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var templates: IdentifiedArrayOf<Template> = []
		@Published var businessDraft: Business?
		@Published var isShowingResetWarning: Bool = false
		
		@Published var isShowingAuthenticateView: Bool = false
		@Published var isLoadingTemplates: Bool = true
		@Published var isCreatingBusiness: Bool = false
		@Published var bannerData: BannerData?
		
		var isUserLoggedIn: Bool {
			AppState.shared.isUserLoggedIn
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let cacheClient: CacheClient = CacheClient.shared
		
		init(draft: Business? = nil) {
			self.businessDraft = draft
		}
		
		func showResetWarning() {
			self.isShowingResetWarning = true
		}
		
		func selectTemplate(_ template: Template) {
			Task {
				let businessDraft: Business = template.business
				await cacheClient.setData(key: .businessDraft, value: businessDraft)
				withAnimation(.default) {
					self.businessDraft = businessDraft
				}
				
				try await Task.sleep(for: .seconds(1.0))
				self.bannerData = BannerData(
					timeOut: 10,
					detail: "This is an example of a business profile. Tap the pencil to personalize it and make it yours 😉"
				)
			}
		}
		
		func refreshTemplates() {
			self.apiClient
				.getTemplates()
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { completion in
						switch completion {
						case .finished: return
						case .failure:
							self.isLoadingTemplates = false
						}
					},
					receiveValue: { templates in
						self.templates = IdentifiedArray(uniqueElements: templates)
						self.isLoadingTemplates = false
					})
				.store(in: &cancellableBag)
		}
		
		func resetBusinessDraft() {
			Task {
				await cacheClient.delete(key: .businessDraft)
				withAnimation(.default) {
					self.bannerData = nil
					self.businessDraft = nil
				}
			}
		}
		
		func setIsShowingAuthenticateView(_ isShowing: Bool) {
			if !isShowing {
				KeyboardClient.shared.resignKeyboard()
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					self.isShowingAuthenticateView = isShowing
				}
				return
			}
			self.isShowingAuthenticateView = isShowing
		}
		
		func getOrUploadImage(url: URL) async -> URL? {
			if url.isFileURL {
				return await self.apiClient.uploadImage(localUrl: url)
			} else {
				return url
			}
		}
		
		func proceed() {
			if isUserLoggedIn {
				self.isCreatingBusiness = true
				Task {
					if let businessDraft = await cacheClient.getData(key: .businessDraft) {
						guard
							let latitude: Double = businessDraft.latitude,
							let longitude: Double = businessDraft.longitude
						else {
							self.isCreatingBusiness = false
							self.bannerData = BannerData(detail: "Please set a location before proceeding")
							return
						}
						
						//Upload the business image to the server
						guard
							let businessImageUrl: URL = await self.getOrUploadImage(url: businessDraft.profilePhoto)
						else {
							self.isCreatingBusiness = false
							self.bannerData = BannerData(detail: "Could not upload business profile image")
							return
						}
						
						//Upload the block images to the server
						var blocks: IdentifiedArrayOf<Business.Block> = []
						await businessDraft.blocks.concurrentForEach { blockDraft in
							if let blockImageUrl = await self.getOrUploadImage(url: blockDraft.image) {
								blocks.append(
									Business.Block(
										id: blockDraft.id,
										blockType: blockDraft.blockType,
										image: blockImageUrl,
										price: blockDraft.price,
										duration: blockDraft.duration,
										title: blockDraft.title,
										description: blockDraft.description
									)
								)
							} else {
								self.isCreatingBusiness = false
								self.bannerData = BannerData(detail: "Could not upload block images")
								return
							}
						}
						
						let newBusiness: CreateBusiness = CreateBusiness(
							sign: businessDraft.sign,
							name: businessDraft.name,
							category: businessDraft.category,
							color: businessDraft.color,
							description: businessDraft.description,
							profilePhoto: businessImageUrl,
							latitude: latitude,
							longitude: longitude,
							blocks: blocks
						)
						apiClient.createBusiness(newBusiness)
							.receive(on: DispatchQueue.main)
							.sink(
								receiveCompletion: { completion in
									switch completion {
									case .finished: return
									case .failure(let error):
										self.isCreatingBusiness = false
										self.bannerData = BannerData(error: error)
									}
								},
								receiveValue: { business in
									self.isCreatingBusiness = false
									AppState.shared.setUserBusiness(business: business)
								}
							)
							.store(in: &cancellableBag)
					}
				}
			} else {
				setIsShowingAuthenticateView(true)
			}
		}
		
		func backToWelcomeScreen() {
			AppState.shared.setAppMode(.welcome(WelcomeView.ViewModel(onboardingVM: .init())))
		}
	}
}
