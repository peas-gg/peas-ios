//
//  EditSiteVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-02.
//

import Combine
import Foundation
import IdentifiedCollections
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
			case schedule
			
			var title: String {
				switch self {
				case .photo: return "Photo"
				case .sign, .name: return "Peas Sign & Name"
				case .description: return "Description"
				case .links: return "Link your socials"
				case .location: return "Location"
				case .block: return "Block"
				case .schedule: return "Your schedule"
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
		
		//Schedule
		@Published var weekDays: [String]
		@Published var dayToEdit: Int?
		@Published var startDateForPicker: Date
		@Published var endDateForPicker: Date
		@Published var schedules: IdentifiedArrayOf<Business.Schedule>?
		
		@Published var isEditingSchedule: Bool = false
		
		@Published var photoItem: PhotosPickerItem?
		@Published var isShowingDeleteBlockAlert: Bool = false
		
		@Published var isLoading: Bool = false
		@Published var bannerData: BannerData?
		
		var locationPermissionState: PermissionState {
			locationClient.permissionState
		}
		
		var isLocationActive: Bool {
			!location.isEmpty && latitude != nil && longitude != nil && locationPermissionState == .allowed
		}
		
		var isValidTimeRange: Bool {
			startDateForPicker < endDateForPicker
		}
		
		var advanceButtonTitle: String {
			switch context {
			case .photo, .sign, .name, .description, .links, .location, .block:
				return "Save"
			case .schedule:
				return isEditingSchedule ? "View your schedule" : "Edit"
			}
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let cacheClient: CacheClient = CacheClient.shared
		private let calendarClient: CalendarClient = CalendarClient.shared
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
			self.blockPriceText = String(block?.price ?? 0)
			self.blockTimeDuration = block?.duration ?? 0
			self.blockTitle = block?.title ?? ""
			self.blockDescription = block?.description ?? ""
			self.blockImage = block?.image ?? "".unwrappedContentUrl
			
			//Links
			self.twitter = business.twitter ?? ""
			self.instagram = business.instagram ?? ""
			self.tiktok = business.tiktok ?? ""
			
			//Schedule
			self.weekDays = calendarClient.weekDays
			self.startDateForPicker = calendarClient.startOfDay
			self.endDateForPicker = calendarClient.endOfDay
			
			self.schedules = business.schedules
			
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
				let imageResized: UIImage = UIImage(data: imageData)?.resizedTo(megaBytes: 1.0) ?? UIImage()
				_ = await self.cacheClient.setImage(url: imageUrl, image: imageResized)
				switch context {
				case .photo:
					self.photo = imageUrl
				case .block:
					self.blockImage = imageUrl
				case .sign, .name, .description, .links, .location, .schedule:
					return
				}
				self.photoItem = nil
				self.isLoading = false
			}
		}
		
		func requestToDeleteBlock() {
			if business.blocks.count == 1 {
				self.bannerData = BannerData(detail: "You cannot delete the last block. You need to offer at least ☝️ service on your site")
			} else {
				self.isShowingDeleteBlockAlert = true
			}
		}
		
		func deleteBlock() {
			if case .block(let blockId) = self.context {
				if let blockIdToDelete = blockId {
					self.isLoading = true
					if isTemplate {
						self.business.blocks.remove(id: blockIdToDelete)
						saveChanges()
						self.isLoading = false
					} else {
						self.deleteBlock(blockId: blockIdToDelete)
					}
				}
			}
		}
		
		func getDateRange(date: Date) -> ClosedRange<Date> {
			let hour = Calendar.current.component(.hour, from: date)
			let minute = Calendar.current.component(.minute, from: date)
			let startDate: Date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: calendarClient.startOfDay)!
			let endDate: Date = calendarClient.endOfDay
			let calendarComponents: Set<Calendar.Component> = [.hour, .minute]
			let startComponents = Calendar.current.dateComponents(calendarComponents, from: startDate)
			let endComponents = Calendar.current.dateComponents(calendarComponents, from: endDate)
			return Calendar.current.date(from: startComponents)!
				...
			Calendar.current.date(from: endComponents)!
		}
		
		func setDayToEdit(dayIndex: Int) {
			if let currentSelectedDayIndex: Int = self.dayToEdit {
				let existingSchedule: Business.Schedule? = schedules?.first(where: { $0.dayOfWeek == currentSelectedDayIndex })
				if startDateForPicker >= endDateForPicker {
					if let existingSchedule = existingSchedule {
						self.schedules?.remove(id: existingSchedule.id)
					}
				} else {
					let startTime: String = ServerDateFormatter.formatToUTC(from: startDateForPicker)
					let endTime: String = ServerDateFormatter.formatToUTC(from: endDateForPicker)
					if var existingSchedule = existingSchedule {
						existingSchedule.startTime = startTime
						existingSchedule.endTime = endTime
						self.schedules?[id: existingSchedule.id] = existingSchedule
					} else {
						let newSchedule: Business.Schedule = Business.Schedule(
							id: UUID().uuidString,
							dayOfWeek: dayIndex,
							startTime: startTime,
							endTime: endTime
						)
						if self.schedules == nil {
							self.schedules = IdentifiedArray(uniqueElements: [newSchedule])
						} else {
							self.schedules?.append(newSchedule)
						}
					}
				}
			}
			
			if self.dayToEdit == dayIndex {
				self.dayToEdit = nil
				self.setPickerDates(start: calendarClient.startOfDay, end: calendarClient.endOfDay)
			} else {
				//Set the time picker for the dayIndex passed
				if let existingSchedule = schedules?.first(where: { $0.dayOfWeek == dayIndex }) {
					let startDate = ServerDateFormatter.formatToDate(from: existingSchedule.startTime)
					let endDate = ServerDateFormatter.formatToDate(from: existingSchedule.endTime)
					self.setPickerDates(start: startDate, end: endDate)
				} else {
					self.setPickerDates(start: calendarClient.startOfDay, end: calendarClient.endOfDay)
				}
				self.dayToEdit = dayIndex
			}
		}
		
		func setPickerDates(start: Date, end: Date) {
			self.startDateForPicker = start
			self.endDateForPicker = end
		}
		
		func updateBusiness(_ model: UpdateBusiness) {
			self.apiClient.updateBusiness(model)
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
					receiveValue: { business in
						self.updateBusiness(business)
					}
				)
				.store(in: &cancellableBag)
		}
		
		func addBlock(_ model: Business.Block) {
			self.apiClient.addBlock(businessId: business.id, model)
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
					receiveValue: { business in
						self.updateBusiness(business)
					}
				)
				.store(in: &cancellableBag)
		}
		
		func updateBlock(_ model: UpdateBusiness.Block) {
			self.apiClient.updateBlock(businessId: business.id, model)
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
					receiveValue: { business in
						self.updateBusiness(business)
					}
				)
				.store(in: &cancellableBag)
		}
		
		func deleteBlock(blockId: Business.Block.ID) {
			self.apiClient.deleteBlock(businessId: business.id, blockId: blockId)
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
					receiveValue: { business in
						self.updateBusiness(business)
					}
				)
				.store(in: &cancellableBag)
		}
		
		func updateBusiness(_ business: Business) {
			self.business = business
			AppState.shared.updateBusiness(business: business)
			self.isLoading = false
			self.onSave(business)
		}
		
		func advance() {
			switch context {
			case .photo, .sign, .name, .description, .links, .location, .block:
				saveChanges()
			case .schedule:
				if isEditingSchedule {
					if dayToEdit == nil {
						//View the schedule
						self.isEditingSchedule = false
					} else {
						//Save the schedule changes
						saveChanges()
					}
				} else {
					//Edit the schedule
					self.isEditingSchedule = true
				}
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
							self.business.blocks[id: id]?.price = Int(self.blockPriceText) ?? 0
							self.business.blocks[id: id]?.duration = self.blockTimeDuration
							self.business.blocks[id: id]?.title = self.blockTitle
							self.business.blocks[id: id]?.description = self.blockDescription
							//Upload Photo
							self.business.blocks[id: id]?.image = self.blockImage
						} else {
							let newBlock: Business.Block = Business.Block(
								id: UUID().uuidString,
								index: business.blocks.count,
								blockType: .Genesis,
								image: self.blockImage,
								price: 0,
								duration: self.blockTimeDuration,
								title:  self.blockTitle,
								description: self.blockDescription,
								isActive: true
							)
							self.business.blocks.append(newBlock)
						}
					case .schedule: return
					}
					self.isLoading = false
					await cacheClient.setData(key: .businessDraft, value: self.business)
					self.onSave(self.business)
				} else {
					self.isLoading = true
					var updateBusinessModel: UpdateBusiness = UpdateBusiness(id: self.business.id)
					switch context {
					case .photo:
						//Upload Photo
						let currentPhoto: URL = self.photo
						if self.business.profilePhoto != currentPhoto {
							if let url = await apiClient.uploadImage(localUrl: currentPhoto) {
								updateBusinessModel.profilePhoto = url
							} else {
								self.bannerData = BannerData(detail: "Could not upload business profile photo")
							}
						}
						updateBusiness(updateBusinessModel)
					case .sign:
						updateBusinessModel.sign = self.sign
						updateBusiness(updateBusinessModel)
					case .name:
						updateBusinessModel.name = self.name
						updateBusiness(updateBusinessModel)
					case .description:
						updateBusinessModel.description = self.description
						updateBusiness(updateBusinessModel)
					case .links:
						updateBusinessModel.twitter = self.twitter
						updateBusinessModel.instagram = self.instagram
						updateBusinessModel.tiktok = self.tiktok
						updateBusiness(updateBusinessModel)
					case .location:
						updateBusinessModel.latitude = self.latitude
						updateBusinessModel.longitude = self.longitude
						updateBusiness(updateBusinessModel)
					case .block(let blockId):
						let currentBlockImage: URL = self.blockImage
						if let blockId = blockId {
							var updateBlockModel: UpdateBusiness.Block = UpdateBusiness.Block(id: blockId)
							updateBlockModel.title = self.blockTitle
							updateBlockModel.description = self.blockDescription
							updateBlockModel.duration = self.blockTimeDuration
							updateBlockModel.price = Int(self.blockPriceText) ?? 0
							if self.business.blocks[id: blockId]?.image != currentBlockImage {
								if let url = await apiClient.uploadImage(localUrl: currentBlockImage) {
									updateBlockModel.image = url
								} else {
									self.isLoading = false
									self.bannerData = BannerData(detail: "Could not upload business profile photo")
								}
							}
							//Update block
							updateBlock(updateBlockModel)
						} else {
							if let imageUrl = await apiClient.uploadImage(localUrl: currentBlockImage) {
								let newBlock = Business.Block(
									id: UUID().uuidString,
									index: self.business.blocks.count,
									blockType: .Genesis,
									image: imageUrl,
									price: Int(self.blockPriceText) ?? 0,
									duration: self.blockTimeDuration,
									title: self.blockTitle,
									description: self.blockDescription,
									isActive: true
								)
								self.addBlock(newBlock)
							} else {
								self.isLoading = false
								self.bannerData = BannerData(detail: "Could not upload business profile photo")
							}
						}
					case .schedule:
						self.apiClient
							.setSchedule(businessId: business.id, schedules?.elements ?? [])
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
								receiveValue: { business in
									self.updateBusiness(business)
								}
							)
							.store(in: &cancellableBag)
					}
				}
			}
		}
	}
}
