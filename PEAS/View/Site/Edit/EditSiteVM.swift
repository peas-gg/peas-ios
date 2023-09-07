//
//  EditSiteVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import Combine
import Foundation
import PhotosUI
import SwiftUI
import UIKit

extension EditSiteView {
	@MainActor class ViewModel: ObservableObject {
		enum Context: Equatable {
			case photo
			case sign
			case name
			case description
			case links
			case location
			case block(_ blockId: Business.Block.ID?)
			
			var title: String {
				switch self {
				case .photo: return "Photo"
				case .sign, .name: return "Peas Sign & Name"
				case .description: return "Description"
				case .links: return "Link your socials"
				case .location: return "Location"
				case .block: return "Block"
				}
			}
		}
		
		let isTemplate: Bool
		let context: Context
		let onSave: (Business) -> ()
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		@Published var business: Business
		
		//Business
		@Published var photo: URL
		@Published var sign: String
		@Published var name: String
		@Published var description: String
		@Published var location: String
		@Published var latitude: Double?
		@Published var longitude: Double?
		
		//Block
		@Published var blockPriceText: String
		@Published var blockTimeDuration: Int
		@Published var blockTitle: String
		@Published var blockDescription: String
		@Published var blockImage: URL
		
		//Links
		@Published var twitter: String
		@Published var instagram: String
		@Published var tiktok: String
		
		@Published var photoItem: PhotosPickerItem?
		@Published var isLoading: Bool = false
		
		@Published var bannerData: BannerData?
		
		var locationPermissionState: PermissionState {
			locationClient.permissionState
		}
		
		var isLocationActive: Bool {
			!location.isEmpty && latitude != nil && longitude != nil && locationPermissionState == .allowed
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let cacheClient: CacheClient = CacheClient.shared
		private let locationClient: LocationClient = LocationClient.shared
		private let permissionClient: PermissionClient = PermissionClient.shared
		
		init(isTemplate: Bool, business: Business, context: Context, onSave: @escaping (Business) -> () = { _ in }) {
			self.isTemplate = isTemplate
			self.context = context
			self.onSave = onSave
			
			self.business = business
			
			//Business
			self.photo = business.profilePhoto
			self.sign = business.sign
			self.name = business.name
			self.description = business.description
			self.location = business.location
			self.latitude = business.latitude
			self.longitude = business.longitude
			
			//Block
			let block: Business.Block? = {
				switch context {
				case .block(let id):
					if let id = id, let existingBlock = business.blocks[id: id] {
						return existingBlock
					}
					return nil
				default: return nil
				}
			}()
			self.blockPriceText = {
				let price = block?.price ?? 0.0
				return PriceFormatter(price: price).text
			}()
			self.blockTimeDuration = block?.duration ?? 0
			self.blockTitle = block?.title ?? ""
			self.blockDescription = block?.description ?? ""
			self.blockImage = block?.image ?? "".unwrappedContentUrl
			
			//Links
			self.twitter = business.twitter ?? ""
			self.instagram = business.instagram ?? ""
			self.tiktok = business.tiktok ?? ""
			
			self.locationClient
				.$location
				.sink { location in
					if let location = location {
						self.updateLocation(locationCoordinate: location)
					}
				}
				.store(in: &cancellableBag)
		}
		
		func locationButtonTapped() {
			switch self.locationPermissionState {
			case .undetermined:
				locationClient.requestForPermission()
			case .allowed:
				requestLocation()
			case .denied:
				permissionClient.openSystemSettings()
			}
		}
		
		func requestLocation() {
			self.isLoading = true
			locationClient.requestLocation()
		}
		
		func updateLocation(locationCoordinate: CLLocationCoordinate2D) {
			let latitude: Double = locationCoordinate.latitude
			let longitude: Double = locationCoordinate.longitude
			
			self.apiClient.getLocation(
				latitude: latitude,
				longitude: longitude
			)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { completion in
					switch completion {
					case .finished: return
					case .failure(let error):
						self.isLoading = false
						self.bannerData = BannerData(error: error)
					}
				},
				receiveValue: { location in
					self.isLoading = false
					self.location = location
					self.latitude = latitude
					self.longitude = longitude
				}
			)
			.store(in: &cancellableBag)
		}
		
		func imageSelected(_ imageData: Data) {
			Task {
				self.isLoading = true
				let imageUrl: URL = cacheClient.fileName(for: UUID().uuidString)
				_ = await self.cacheClient.setImage(url: imageUrl, image: UIImage(data: imageData) ?? UIImage())
				switch context {
				case .photo:
					self.photo = imageUrl
				case .block:
					self.blockImage = imageUrl
				case .sign, .name, .description, .links, .location:
					return
				}
				self.photoItem = nil
				self.isLoading = false
			}
		}
		
		func saveChanges() {
			Task {
				if isTemplate {
					self.isLoading = true
					switch self.context {
					case .sign, .name, .description:
						self.business.sign = self.sign
						self.business.name = self.name
						self.business.description = self.description
					case .photo:
						self.business.profilePhoto = self.photo
					case .links:
						self.business.twitter = self.twitter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : self.twitter
						self.business.instagram = self.instagram.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : self.instagram
						self.business.tiktok = self.tiktok.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : self.tiktok
					case .location:
						self.business.location = self.location
						self.business.latitude = self.latitude
						self.business.longitude = self.longitude
					case .block(let id):
						if let id = id {
							self.business.blocks[id: id]?.price = PriceFormatter(text: self.blockPriceText).price
							self.business.blocks[id: id]?.duration = self.blockTimeDuration
							self.business.blocks[id: id]?.title = self.blockTitle
							self.business.blocks[id: id]?.description = self.blockDescription
							//Upload Photo
							self.business.blocks[id: id]?.image = self.blockImage
						} else {
							let newBlock: Business.Block = Business.Block(
								id: UUID().uuidString,
								blockType: .Genesis,
								image: self.blockImage,
								price: PriceFormatter(text: self.blockPriceText).price,
								duration: self.blockTimeDuration,
								title:  self.blockTitle,
								description: self.blockDescription
							)
							self.business.blocks.append(newBlock)
						}
					}
					self.isLoading = false
					await cacheClient.setData(key: .businessDraft, value: self.business)
					self.onSave(self.business)
				}
			}
		}
	}
}
