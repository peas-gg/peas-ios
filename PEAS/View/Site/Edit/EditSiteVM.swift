//
//  EditSiteVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

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
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let cacheClient: CacheClient = CacheClient.shared
		
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
			self.blockPriceText = block?.price.priceToText ?? ""
			self.blockTimeDuration = block?.duration ?? 0
			self.blockTitle = block?.title ?? ""
			self.blockDescription = block?.description ?? ""
			self.blockImage = block?.image ?? "".unwrappedContentUrl
			
			//Links
			self.twitter = business.twitter ?? ""
			self.instagram = business.instagram ?? ""
			self.tiktok = business.tiktok ?? ""
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
			if isTemplate {
				Task {
					self.isLoading = true
					switch context {
					case .sign, .name, .description:
						self.business.sign = self.sign
						self.business.name = self.name
						self.business.description = self.description
					case .photo:
						self.business.profilePhoto = self.photo
						return
					case .links:
						self.business.twitter = self.twitter
						self.business.instagram = self.instagram
						self.business.tiktok = self.tiktok
					case .location:
						self.business.latitude = self.latitude
						self.business.longitude = self.longitude
					case .block(let id):
						if let id = id {
							self.business.blocks[id: id]?.price = Double(self.blockPriceText) ?? 0.0
							self.business.blocks[id: id]?.duration = self.blockTimeDuration
							self.business.blocks[id: id]?.title = self.blockTitle
							self.business.blocks[id: id]?.description = self.description
							//Upload Photo
							self.business.blocks[id: id]?.image = self.blockImage
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
