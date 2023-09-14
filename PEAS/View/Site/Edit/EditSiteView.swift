//
//  EditSiteView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-27.
//

import PhotosUI
import SwiftUI

struct EditSiteView: View {
	@StateObject var viewModel: EditSiteView.ViewModel
	
	enum FocusField: Hashable {
		case sign
		case name
		case description
		case blockPrice
	}
	
	let textfieldVerticalPadding: CGFloat = 12
	
	@FocusState private var focusedField: FocusField?
	
	@State var isPriceKeyboardFocused: Bool = false
	
	init(viewModel: EditSiteView.ViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}
	
	var body: some View {
		VStack(spacing: 0) {
			let horizontalPadding: CGFloat = 25
			Text(viewModel.context.title)
				.font(Font.app.title2)
				.foregroundColor(Color.app.primaryText)
				.padding(.top)
			Divider()
				.padding(.top)
			VStack {
				let spacing: CGFloat = 20
				switch viewModel.context {
				case .photo:
					VStack(alignment: .center, spacing: spacing) {
						hintText(content: "Think of your business photo as your brand image")
						HStack {
							Spacer()
							photoPickerButton {
								CachedAvatar(url: viewModel.photo, height: 200)
									.overlay {
										Image(systemName: "photo")
											.font(Font.app.largeTitle)
											.foregroundColor(Color.app.tertiaryText)
									}
							}
							Spacer()
						}
						hintText(content: "We recommend a photo of yourself because a face helps to build trust")
						Spacer()
					}
					.multilineTextAlignment(.center)
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				case .sign, .name:
					VStack(alignment: .leading, spacing: spacing) {
						hintText(content: "Choose a unique peas sign to make it easy for people to find and remember you")
							.fixedSize(horizontal: false, vertical: true)
						HStack {
							Image("SiteLogo")
								.resizable()
								.scaledToFit()
								.frame(dimension: 50)
							textField(hint: "Your Sign", leadingHint: "/", text: $viewModel.sign)
								.font(Font.app.bodySemiBold)
								.focused($focusedField, equals: .sign)
						}
						.padding(.bottom, 40)
						hintText(content: "Feel free to get a little creative with your business name")
							.fixedSize(horizontal: false, vertical: true)
						textField(hint: "Business Name", text: $viewModel.name)
							.font(Font.app.bodySemiBold)
							.focused($focusedField, equals: .name)
						Spacer(minLength: 0)
					}
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				case .description:
					VStack(alignment: .center, spacing: spacing) {
						HStack {
							Spacer()
						}
						hintText(content: "Tell people about what you do and what services you offer here. Don't sell yourself short ;)")
						descriptionTextField(hint: "Describe your business here", text: $viewModel.description, textLimit: SizeConstants.businessDescriptionLimit)
						Spacer()
					}
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				case .block(let blockId):
					ScrollView(showsIndicators: false) {
						VStack(alignment: .leading, spacing: 30) {
							HStack {
								Spacer()
								photoPickerButton {
									blockImage(viewModel.blockImage)
								}
								Spacer()
							}
							.padding(.top, 30)
							blockPricingSection()
							blockTimeSection()
							VStack(alignment: .leading, spacing: 10) {
								hintText(content: "Service")
								textField(hint: "Add a title for your package", hintImage: "text.insert", text: $viewModel.blockTitle)
									.font(Font.app.title2Display)
									.multilineTextAlignment(.center)
								descriptionTextField(hint: "Describe the package", text: $viewModel.blockDescription, textLimit: SizeConstants.descriptionLimit)
								HStack {
									Spacer()
									Button(action: { viewModel.requestToDeleteBlock() }) {
										HStack {
											Image(systemName: "trash")
											Text("Delete")
										}
										.font(Font.app.body)
										.padding()
										.background(textBackground())
									}
									.disabled(blockId == nil)
									Spacer()
								}
								.padding(.top)
							}
							Spacer()
						}
						.padding(.horizontal, horizontalPadding)
					}
					.alert(isPresented: $viewModel.isShowingDeleteBlockAlert) {
						Alert(
							title: Text("Are you sure you want to delete this block?"),
							message: Text("You cannot undo this. The block will be deleted from your site."),
							primaryButton: .destructive(Text("Delete")) {
								viewModel.deleteBlock()
							},
							secondaryButton: .cancel()
						)
					}
				case .links:
					VStack(alignment: .leading, spacing: spacing) {
						hintText(content: "Link your social media accounts below so people can follow you and stay up to date on your journey")
						linkField(image: "X", text: $viewModel.twitter)
						linkField(image: "Instagram", text: $viewModel.instagram)
						linkField(image: "Tiktok", text: $viewModel.tiktok)
						Spacer()
					}
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				case .location:
					VStack {
						let image: String = {
							switch viewModel.locationPermissionState {
							case .undetermined: return "location.fill"
							case .allowed: return "arrow.clockwise"
							case .denied: return "gear"
							}
						}()
						let text: String = {
							switch viewModel.locationPermissionState {
							case .undetermined, .denied: return "Enable Location"
							case .allowed: return "Update"
							}
						}()
						HStack {
							Spacer()
							Button(action: { viewModel.locationButtonTapped() }) {
								HStack {
									Image(systemName: image)
									Text(text)
										.textCase(.uppercase)
								}
								.font(Font.app.captionSemiBold)
								.foregroundColor(Color.app.secondaryText)
								.padding(8)
								.background(
									RoundedRectangle(cornerRadius: SizeConstants.textCornerRadius)
										.fill(Color.black)
								)
							}
							.padding(.trailing)
							.padding(.trailing)
						}
						Spacer()
						ZStack(alignment: .bottom) {
							PulseView(size: 200, isActive: viewModel.isLocationActive)
							Text(viewModel.location)
								.font(Font.app.title1)
								.foregroundColor(Color.app.primaryText)
								.padding(.bottom, 30)
						}
						Spacer()
					}
					.padding(.top)
					.presentationDetents([.height(400)])
				case .schedule:
					VStack(spacing: spacing) {
						VStack(alignment: .leading) {
							HStack {
								Text("Availability")
								Spacer()
							}
							HStack {
								ForEach(viewModel.weekDays.indices, id: \.self) { index in
									dayView(day: viewModel.weekDays[index])
									if index != viewModel.weekDays.count - 1 {
										Spacer(minLength: 0)
									}
								}
							}
						}
						VStack(alignment: .leading) {
							HStack {
								Text("Select time")
								Spacer()
							}
							HStack {
								timeSelection(date: $viewModel.startDate, dateRange: viewModel.startDateRange)
								Spacer()
								Image(systemName: "arrow.right")
									.font(Font.app.bodySemiBold)
									.foregroundColor(Color.app.primaryText)
								Spacer()
								timeSelection(date: $viewModel.endDate, dateRange: viewModel.endDateRange)
							}
							.disabled(viewModel.selectedDay == nil)
						}
						HStack {
							Spacer(minLength: 0)
							Text("Please note that updating your schedule does not change the time for existing appointments")
								.font(Font.app.footnote)
								.multilineTextAlignment(.center)
							Spacer(minLength: 0)
						}
						.padding(.top, 40)
					}
					.font(Font.app.body)
					.foregroundColor(Color.app.tertiaryText)
					.padding(.top)
					.padding(.horizontal, horizontalPadding)
				}
			}
			.background(viewModel.context == .location ? Color.app.primaryBackground : Color.app.secondaryBackground)
			
			if viewModel.context != .location {
				Spacer()
			}
			
			let isSchedule: Bool = viewModel.context == .schedule
			Button(action: { viewModel.saveChanges() }) {
				Text(isSchedule ? "Set Schedule" : "Save")
			}
			.buttonStyle(.expanded(style: isSchedule ? .green : .black))
			.padding()
		}
		.multilineTextAlignment(.leading)
		.tint(Color.app.primaryText)
		.progressView(isShowing: viewModel.isLoading, style: .black)
		.banner(data: $viewModel.bannerData)
		.onChange(of: focusedField) { focusField in
			if focusField != nil {
				self.isPriceKeyboardFocused = false
			}
		}
		.onChange(of: viewModel.photoItem) { photoItem in
			Task {
				if let data = try? await photoItem?.loadTransferable(type: Data.self) {
					viewModel.imageSelected(data)
				}
			}
		}
		.onAppear {
			switch viewModel.context {
			case .sign:
				self.focusedField = .sign
			case .name:
				self.focusedField = .name
			case .description:
				self.focusedField = .description
			case .links:
				self.focusedField = nil
			case .photo, .block, .location, .schedule:
				return
			}
		}
	}
	
	@ViewBuilder
	func hintText(content: String) -> some View {
		Text(content)
			.font(Font.app.body)
			.foregroundColor(Color.app.tertiaryText)
	}
	
	@ViewBuilder
	func textField(hint: String, hintImage: String? = nil, leadingHint: String? = nil, text: Binding<String>) -> some View {
		HStack {
			if let leadingHint = leadingHint {
				Text("\(leadingHint)")
					.font(Font.app.title2)
					.foregroundColor(Color.app.tertiaryText)
			}
			ZStack(alignment: hintImage == nil ? .leading : .center) {
				textHint(image: hintImage, hint: hint, text: text.wrappedValue)
				TextField("", text: text)
			}
		}
		.foregroundColor(Color.app.primaryText)
		.padding(.horizontal)
		.padding(.vertical, textfieldVerticalPadding)
		.background(textBackground())
	}
	
	@ViewBuilder
	func descriptionTextField(hint: String, text: Binding<String>, textLimit: Int) -> some View {
		ZStack(alignment: .center) {
			textHint(image: "text.viewfinder", hint: hint, text: text.wrappedValue)
			VStack {
				TextField("", text: text.max(textLimit), axis: .vertical)
					.font(.system(size: FontSizes.body, weight: .regular, design: .default))
					.lineLimit(4, reservesSpace: true)
					.focused($focusedField, equals: .description)
				HStack {
					Spacer()
					Text("\(text.wrappedValue.count)/\(textLimit)")
						.foregroundColor(Color.app.tertiaryText)
				}
			}
		}
		.font(Font.app.footnote)
		.padding()
		.background(textBackground())
	}
	
	@ViewBuilder
	func blockPricingSection() -> some View {
		VStack(alignment: .leading, spacing: 6) {
			hintText(content: "Pricing")
			HStack {
				Text("$")
					.foregroundColor(Color.app.tertiaryText)
				PriceTextField(isFocused: $isPriceKeyboardFocused, priceText: $viewModel.blockPriceText)
			}
			.font(Font.app.bodySemiBold)
			.padding(.horizontal)
			.padding(.vertical, textfieldVerticalPadding)
			.background(textBackground())
			.onTapGesture {
				self.isPriceKeyboardFocused.toggle()
			}
		}
	}
	
	@ViewBuilder
	func blockTimeSection() -> some View {
		VStack(alignment: .leading, spacing: 10) {
			hintText(content: "How long will it take you to deliver this service?")
			HStack {
				Text("\(viewModel.blockTimeDuration.timeSpan)")
					.font(Font.app.largeTitle)
					.foregroundColor(Color.app.primaryText)
				Spacer()
				StepperView(min: 0, max: 86400, step: 300, value: $viewModel.blockTimeDuration)
			}
		}
	}
	
	@ViewBuilder
	func linkField(image: String, text: Binding<String>) -> some View {
		HStack(spacing: 20) {
			Image(image)
				.resizable()
				.scaledToFit()
				.frame(dimension: 46)
			textField(hint: "", leadingHint: "@", text: text)
				.font(Font.app.bodySemiBold)
		}
	}
	
	@ViewBuilder
	func blockImage(_ imageUrl: URL) -> some View {
		let cornerRadius: CGFloat = SizeConstants.blockCornerRadius
		let size: CGSize = CGSize(width: 180, height: 260)
		CachedImage(
			url: imageUrl,
			content: { uiImage in
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFill()
					.frame(size: size)
					.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
					.opacity(0.8)
			},
			placeHolder: {
				ZStack {
					RoundedRectangle(cornerRadius: cornerRadius)
						.fill(Color.app.primaryBackground)
					RoundedRectangle(cornerRadius: cornerRadius)
						.stroke(Color.app.tertiaryText.opacity(0.5), lineWidth: 1)
				}
				.frame(size: size)
			}
		)
		.overlay {
			Image(systemName: "photo")
				.font(Font.app.largeTitle)
				.foregroundColor(Color.app.tertiaryText)
		}
		.id(imageUrl)
	}
	
	@ViewBuilder
	func photoPickerButton<Label: View>(label: @escaping () -> Label) -> some View {
		PhotosPicker(selection: $viewModel.photoItem, matching: .images) {
			label()
		}
		.buttonStyle(.plain)
	}
	
	@ViewBuilder
	func dayView(day: String) -> some View {
		let isActive: Bool = viewModel.availableDays.contains(day)
		let foregroundColor: Color = isActive ? Color.app.secondaryText : Color.app.primaryText
		let opacity: CGFloat = {
			if let selectedDay = viewModel.selectedDay {
				return selectedDay == day ? 1.0 : 0.2
			} else {
				return 1.0
			}
		}()
		Button(action: { viewModel.setSelectedDay(day: day) }) {
			Color.clear
				.overlay {
					Group {
						if isActive {
							RoundedRectangle(cornerRadius: SizeConstants.textCornerRadius)
								.fill(Color.app.accent)
						} else {
							textBackground()
						}
					}
				}
				.frame(dimension: 44)
				.overlay {
					if let firstLetter = day.first {
						Text(String(firstLetter))
							.font(Font.app.bodySemiBold)
							.foregroundColor(foregroundColor)
					}
				}
				.opacity(opacity)
				.transition(.opacity)
				.animation(.easeInOut, value: opacity)
		}
	}
	
	@ViewBuilder
	func timeSelection(date: Binding<Date>, dateRange: ClosedRange<Date>) -> some View {
		HStack {
			Image(systemName: "clock")
				.font(Font.app.title2)
				.foregroundColor(Color.app.tertiaryText)
			DatePicker("", selection: date, in: dateRange, displayedComponents: .hourAndMinute)
				.labelsHidden()
		}
		.font(Font.app.bodySemiBold)
		.foregroundColor(Color.app.primaryText)
	}
	
	@ViewBuilder
	func textHint(image: String?, hint: String, text: String) -> some View {
		HStack {
			if let image = image {
				Image(systemName: image)
			}
			Text(hint)
		}
		.font(Font.app.callout)
		.foregroundColor(Color.app.tertiaryText)
		.opacity(text.count > 0 ? 0.0 : 1.0)
	}
	
	@ViewBuilder
	func textBackground() -> some View {
		let cornerRadius: CGFloat = SizeConstants.textCornerRadius
		RoundedRectangle(cornerRadius: cornerRadius)
			.fill(Color.white)
		RoundedRectangle(cornerRadius: cornerRadius)
			.stroke(Color.app.tertiaryText.opacity(0.5))
	}
}

struct EditSiteView_Previews: PreviewProvider {
	static var previews: some View {
		EditSiteView(viewModel: .init(isTemplate: true, business: Business.mock1, context: .photo))
		EditSiteView(viewModel: .init(isTemplate: true, business: Business.mock1, context: .location))
		EditSiteView(viewModel: .init(isTemplate: true, business: Business.mock1, context: .links))
		EditSiteView(viewModel: .init(isTemplate: true, business: Business.mock1, context: .block(Business.mock1.blocks.first!.id)))
		EditSiteView(viewModel: .init(isTemplate: true, business: Business.mock1, context: .schedule))
	}
}
