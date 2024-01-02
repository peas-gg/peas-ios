//
//  OrderView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-22.
//

import SwiftUI

struct OrderView: View {
	@StateObject var viewModel: ViewModel
	
	//Clients
	let calendarClient: CalendarClient = CalendarClient.shared
	
	var body: some View {
		Group {
			switch viewModel.context {
			case .detail:
				VStack {
					VStack {
						HStack(alignment: .top, spacing: 20) {
							VStack {
								image()
							}
							let alignment: HorizontalAlignment = .leading
							VStack(alignment: alignment, spacing: 20) {
								HStack {
									VStack(alignment: alignment) {
										title("Plan:")
										label(viewModel.order.title)
									}
									Spacer(minLength: 0)
									statusBadge()
								}
								VStack(alignment: alignment) {
									title("Price:")
									Text("$\(PriceFormatter.price(value: String(viewModel.orderAmount)))")
										.font(Font.app.largeTitle)
										.foregroundColor(viewModel.isOrderPaidFor ? Color.app.accent : Color.app.primaryText)
								}
								VStack(alignment: alignment) {
									title("Customer:")
									Button(action: { viewModel.setSheet(.customer) }) {
										label(customerName())
											.underline()
									}
								}
								VStack(alignment: alignment) {
									title("Time & Date:")
									label("\(formattedTime())")
								}
							}
						}
						note()
							.padding(.top)
						changeStatusButtons()
					}
					.padding(.horizontal)
					.padding(.vertical)
					.background(CardBackground())
					.padding()
					Spacer()
					Button(action: { viewModel.requestPayment() }) {
						Text(viewModel.order.didRequestPayment ? "Requested..." : "Request Payment")
					}
					.buttonStyle(.expanded(style: .green))
					.padding(.bottom)
					.opacity(viewModel.canRequestPayment ? 1.0 : 0.0)
				}
				.background(Color.app.secondaryBackground)
			case .dashboard:
				compactView()
			case .calendar:
				HStack(spacing: 10) {
					VStack(spacing: 2) {
						let startTime: String = TimeFormatter.getServerTime(date: viewModel.order.startTimeDateLocal)
						let endTime: String = TimeFormatter.getServerTime(date: viewModel.order.endTimeDateLocal)
						Text(startTime)
						ForEach(0..<3) {
							Circle()
								.fill(Color.gray)
								.frame(dimension: 3)
								.id($0)
						}
						Text(endTime)
						Text(getTimeDifference())
							.font(Font.app.footnote)
							.foregroundColor(Color.app.tertiaryText)
					}
					.font(.system(size: FontSizes.footnote, weight: .semibold, design: .rounded))
					.foregroundColor(Color.app.primaryText)
					.frame(maxWidth: 70)
					compactView()
						.padding(8)
						.background(CardBackground())
				}
				.padding(.horizontal)
				.opacity(viewModel.order.orderStatus == .Completed ? 0.6 : 1.0)
			}
		}
		.progressView(isShowing: viewModel.isLoading, style: .white)
		.banner(data: $viewModel.bannerData)
		.alert(
			isPresented: Binding(
				get: { viewModel.action != nil } ,
				set: { _ in viewModel.resetAlert() }
			)
		) {
			if let alert = viewModel.action {
				let title: String = alert.rawValue.capitalized
				return Alert(
					title: Text("Are you sure you would like to \"\(title)\" this reservation?"),
					message: Text("This action is not reversible"),
					primaryButton: {
						if alert == .decline  {
							return .destructive(Text("\(title)")) {
								viewModel.declineOrder()
							}
						} else {
							return .default(Text("\(title)")) {
								switch alert {
								case .decline: return
								case .approve: viewModel.approveOrder()
								case .complete: viewModel.completeOrder()
								}
							}
						}
					}(),
					secondaryButton: .cancel()
				)
			}
			return Alert(title: Text("Something went wrong"))
		}
		.sheet(
			item: $viewModel.sheet,
			onDismiss: {},
			content: { sheet in
				Group {
					switch sheet {
					case .customer:
						CustomerView(customer: viewModel.order.customer, context: .detail)
					case .datePicker:
						datePickerView()
					}
				}
				.progressView(isShowing: viewModel.isProcessingSheetRequest, style: .black)
				.banner(data: $viewModel.sheetBannerData)
			}
		)
	}
	
	@ViewBuilder
	func datePickerView() -> some View {
		VStack(spacing: 0) {
			SheetHeaderView(title: "Update Time")
			VStack {
				VStack(alignment: .leading) {
					hintText("Day")
					DateTimePicker(context: .day, date: $viewModel.dayForPicker)
					hintText("Time")
						.padding(.top)
					HStack {
						Spacer()
						subTitleText("Starts")
						Spacer()
						Spacer()
						subTitleText("Ends")
						Spacer()
					}
					HStack {
						DateTimePicker(context: .time, date: $viewModel.startDateForPicker)
						Spacer()
						Spacer()
						DateTimePicker(context: .time, date: $viewModel.endDateForPicker)
					}
					HStack {
						Spacer(minLength: 0)
						let startDate: Date = viewModel.startDateForPicker
						let endDate: Date = viewModel.endDateForPicker
						Text("\(endDate.getTimeSpan(from: startDate).timeSpan)")
							.font(Font.app.title2)
							.foregroundStyle(Color.app.primaryText)
						Spacer(minLength: 0)
					}
					.padding(.top)
					Spacer(minLength: 0)
				}
				.padding(.horizontal, SizeConstants.horizontalPadding)
				.padding(.top)
				Button(action: { viewModel.updateOrderTime() }) {
					Text("Save")
				}
				.buttonStyle(.expanded)
				.disabled(!viewModel.isOrderTimeValid)
				.padding(.horizontal, 10)
			}
			.background(Color.app.secondaryBackground)
		}
		.presentationDetents([.height(400)])
	}
	
	@ViewBuilder
	func compactView() -> some View {
		HStack {
			image()
			VStack(alignment: .leading, spacing: 4) {
				HStack {
					label(viewModel.order.title)
					Spacer(minLength: 0)
					switch viewModel.context {
					case .dashboard:
						statusBadge()
					case .detail, .calendar:
						EmptyView()
					}
				}
				HStack(spacing: 20) {
					Text("$\(PriceFormatter.price(value: String(viewModel.orderAmount)))")
						.font(Font.app.body)
						.foregroundColor(viewModel.isOrderPaidFor ? Color.app.accent : Color.app.primaryText)
					timeView()
				}
				HStack(spacing: 6) {
					Button(action: { viewModel.setSheet(.customer) }) {
						Text(customerName())
							.foregroundColor(Color.app.primaryText)
							.underline()
							.lineLimit(1)
					}
					Spacer(minLength: 0)
					Image(systemName: "doc.text")
						.font(.system(size: FontSizes.title3, weight: .semibold))
						.opacity(viewModel.order.validNote == nil ? 0.0 : 1.0)
				}
				.font(Font.app.body)
				.foregroundColor(Color.app.tertiaryText)
			}
		}
		.background(Color.white.opacity(0.001))
	}
	
	@ViewBuilder
	func title(_ content: String) -> some View {
		Text(content)
			.font(Font.app.footnote)
			.foregroundColor(Color.app.tertiaryText)
			.lineLimit(1)
	}
	
	@ViewBuilder
	func hintText(_ content: String) -> some View {
		Text(content)
			.font(Font.app.body)
			.foregroundColor(Color.app.tertiaryText)
	}
	
	@ViewBuilder
	func subTitleText(_ content: String) -> some View {
		Text(content)
			.font(Font.system(size: 16, weight: .semibold, design: .rounded))
			.foregroundColor(Color.app.tertiaryText)
	}
	
	@ViewBuilder
	func label(_ content: String) -> some View {
		Text(content)
			.font(Font.app.bodySemiBold)
			.foregroundStyle(Color.app.primaryText)
			.lineLimit(1)
	}
	
	@ViewBuilder
	func image() -> some View {
		let size: CGSize = CGSize(width: 50, height: 70)
		let cornerRadius: CGFloat = 6
		RoundedRectangle(cornerRadius: cornerRadius)
			.fill(Color.white)
			.frame(size: size)
			.overlay(
				CachedImage(
					url: viewModel.order.image,
					content: { uiImage in
						Image(uiImage: uiImage)
							.resizable()
							.scaledToFill()
							.frame(size: size)
					},
					placeHolder: {
						RoundedRectangle(cornerRadius: cornerRadius)
							.fill(Color.gray.opacity(0.2))
							.overlay(ProgressView())
					}
				)
				.frame(size: size)
				.cornerRadius(cornerRadius)
			)
			.id(viewModel.order.image)
		
		
	}
	
	@ViewBuilder
	func statusBadge() -> some View {
		let status: Order.Status = viewModel.order.orderStatus
		Text(viewModel.order.orderStatus.rawValue)
			.font(.system(size: 10, weight: .semibold, design: .rounded))
			.textCase(.uppercase)
			.foregroundColor(status.foregroundColor)
			.padding(4)
			.padding(.horizontal, 6)
			.background(status.backgroundColor)
			.cornerRadius(5)
	}
	
	@ViewBuilder
	func note() -> some View {
		if let note = viewModel.order.validNote {
			Text(note)
				.font(Font.app.body)
				.foregroundColor(Color.app.primaryText)
				.padding()
				.background(CardBackground(style: .lightGray))
				.overlay(alignment: .topLeading) {
					Image(systemName: "paperclip")
						.font(Font.app.title2)
						.rotationEffect(.degrees(-190))
						.offset(x: -6, y: -10)
				}
		}
	}
	
	@ViewBuilder
	func changeStatusButtons() -> some View {
		let orderStatus: Order.Status = viewModel.order.orderStatus
		VStack {
			switch orderStatus {
			case .Pending:
				Divider()
					.padding(.vertical)
			case .Approved:
				HStack {
					Spacer()
					button(isProminent: true, symbol: "clock", title: "Update Time", cardStyle: .white) {
						viewModel.setSheet(.datePicker)
					}
				}
				.padding(.top)
				Divider()
					.padding(.vertical)
			case .Declined, .Completed:
				EmptyView()
			}
			HStack {
				Spacer()
				HStack(spacing: 10) {
					switch orderStatus {
					case .Pending:
						declineButton()
						approveButton()
					case .Approved:
						if viewModel.order.payment == nil {
							declineButton()
						}
						completeButton()
					case .Declined, .Completed:
						EmptyView()
					}
				}
			}
		}
	}
	
	@ViewBuilder
	func approveButton() -> some View {
		button(isProminent: true, symbol: "checkmark", title: "Approve", foregroundColor: Color.app.secondaryText, cardStyle: .black) {
			viewModel.requestAction(action: .approve)
		}
	}
	
	@ViewBuilder
	func declineButton() -> some View {
		button(isProminent: false, symbol: "xmark", title: "Decline", cardStyle: .white) {
			viewModel.requestAction(action: .decline)
		}
	}
	
	@ViewBuilder
	func completeButton() -> some View {
		button(isProminent: true, symbol: "checkmark", title: "Complete", cardStyle: .white) {
			viewModel.requestAction(action: .complete)
		}
	}
	
	@ViewBuilder
	func button(
		isProminent: Bool,
		symbol: String,
		title: String,
		foregroundColor: Color = Color.app.primaryText,
		cardStyle: CardBackground.Style,
		action: @escaping () -> ()
	) -> some View {
		Button(action: { action() }) {
			HStack {
				Image(systemName: symbol)
				ZStack {
					Text(title)
						.font(Font.app.bodySemiBold)
						.opacity(0)
					Text(title)
				}
			}
			.font(isProminent ? Font.app.bodySemiBold : Font.app.callout)
			.foregroundColor(foregroundColor)
			.padding(10)
			.background(CardBackground(style: cardStyle))
		}
	}
	
	@ViewBuilder
	func timeView() -> some View {
		let nowText: String = "Now"
		let order: Order = viewModel.order
		
		let timeDisplay: String = {
			if Date.now.isBetween(order.startTimeDate, and: order.endTimeDate) {
				return nowText
			} else {
				return order.startTimeDate.timeAgoDisplay()
			}
		}()
		Text(" •  \(timeDisplay) ")
			.font(Font.app.body)
			.foregroundColor(timeDisplay == nowText ? Color.app.accent : Color.app.tertiaryText)
			.lineLimit(1)
	}
	
	func formattedTime() -> String {
		let date: Date = viewModel.order.startTimeDate
		let components = Calendar.current.dateComponents([.month, .day, .weekday], from: date)
		
		let time: String = TimeFormatter.getLocalTime(date: date)
		let weekDay: String = {
			if let weekDay = components.weekday {
				return calendarClient.weekDaysShort[weekDay - 1]
			}
			return ""
		}()
		let month: String = {
			if let month = components.month {
				return calendarClient.monthFormatter.shortMonthSymbols[month - 1]
			}
			return ""
		}()
		let day: String = {
			if let day = components.day {
				return String(day)
			}
			return ""
		}()
		return "\(time)  @  \(weekDay), \(month) \(day)"
	}
	
	func getTimeDifference() -> String {
		let timeComponents: DateComponents = Calendar.current.dateComponents([.hour, .minute], from: viewModel.order.startTimeDateLocal, to: viewModel.order.endTimeDateLocal)
		var hourText: String = ""
		var minuteText: String = ""
		if let hour = timeComponents.hour {
			hourText = hour > 0 ? "\(hour)h" : ""
		}
		if let minute = timeComponents.minute {
			minuteText = minute > 0 ? "\(minute)m" : ""
		}
		if hourText.isEmpty && minuteText.isEmpty {
			return ""
		} else {
			return "(\(hourText) \(minuteText))"
		}
	}
	
	func customerName() -> String {
		return "\(viewModel.order.customer.firstName) \(viewModel.order.customer.lastName)"
	}
}

struct OrderView_Previews: PreviewProvider {
	static var previews: some View {
		OrderView(viewModel: .init(context: .detail, business: Business.mock1, order: Order.mock1))
		OrderView(viewModel: .init(context: .detail, business: Business.mock1, order: Order.mock2))
		OrderView(viewModel: .init(context: .dashboard, business: Business.mock1, order: Order.mock2))
		VStack {
			Spacer()
			OrderView(viewModel: .init(context: .calendar, business: Business.mock1, order: Order.mock1))
			OrderView(viewModel: .init(context: .calendar, business: Business.mock1, order: Order.mock2))
			Spacer()
		}
		.background(Color.app.secondaryBackground)
	}
}
