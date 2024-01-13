//
//  SiteVM.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import Combine
import Foundation
import SwiftUI

extension SiteView {
	@MainActor class ViewModel: ObservableObject {
		let isTemplate: Bool
		
		private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
		
		var hasSocialLink: Bool {
			business.twitter != nil || business.instagram != nil || business.tiktok != nil
		}
		
		@Published var colours: Dictionary<String, String> = Dictionary<String, String>()
		@Published var business: Business
		@Published var isInEditMode: Bool = false
		@Published var editModeContext: EditSiteView.ViewModel.Context?
		@Published var isShowingSocialLinksMenu: Bool = false
		
		var siteUrl: URL? {
			URL(string: "\(AppConstants().appUrlString)\(business.sign)")
		}
		
		//Clients
		private let apiClient: APIClient = APIClient.shared
		private let cacheClient: CacheClient = CacheClient.shared
		
		init(isTemplate: Bool, business: Business) {
			self.isTemplate = isTemplate
			self.business = business
			self.apiClient
				.getColours()
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { _ in },
					receiveValue: { colours in
						self.colours = colours
					})
				.store(in: &cancellableBag)
			
			//Register for Notifications
			NotificationCenter
				.default.addObserver(
					self,
					selector: #selector(updateBusiness),
					name: .updateBusiness,
					object: nil
				)
		}
		
		func setBackgroundColor(colorName: String) {
			self.business.color = colorName
		}
		
		func setEditModeContext(_ context: EditSiteView.ViewModel.Context?) {
			self.editModeContext = context
		}
		
		func showSocialLinks() {
			withAnimation(.default) {
				self.isShowingSocialLinksMenu = true
			}
		}
		
		func toggleEditMode() {
			self.isInEditMode.toggle()
			Task {
				if !self.isInEditMode {
					//Save Colour
					if isTemplate {
						await cacheClient.setData(key: .businessDraft, value: self.business)
					} else {
						let updateBusinessModel: UpdateBusiness = UpdateBusiness(id: self.business.id, color: self.business.color)
						self.apiClient
							.updateBusiness(updateBusinessModel)
							.receive(on: DispatchQueue.main)
							.sink(
								receiveCompletion: { _ in },
								receiveValue: { business in
									self.business = business
									AppState.shared.updateBusiness(business: business)
								}
							)
							.store(in: &cancellableBag)
					}
				}
			}
		}
		
		func dismissEditContext() {
			Task {
				if let business = await self.cacheClient.getData(key: .businessDraft),
				   isTemplate {
					self.business = business
				}
				self.editModeContext = nil
			}
		}
		
		@objc func updateBusiness(_ notification: Notification) {
			if let userInfo = notification.userInfo as? [String : Business],
			   let business: Business = userInfo[NotificationKey.business]
			{
				self.business = business
			}
		}
	}
}
