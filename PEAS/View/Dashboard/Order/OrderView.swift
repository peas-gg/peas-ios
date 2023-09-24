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
										.foregroundColor(viewModel.order.payment == nil ? Color.app.primaryText : Color.app.accent)
								}
								VStack(alignment: alignment) {
									title("Customer:")
									Button(action: { viewModel.openCustomerView() }) {
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
					.padding(.horizontal)
					Spacer()
					Button(action: { viewModel.requestPayment() }) {
						Text(viewModel.order.didRequestPayment ? "Requested..." : "Request Payment")
					}
					.buttonStyle(.expanded(style: .green))
					.padding(.bottom)
				}
			case .dashboard:
				compactView()
			case .calendar:
				HStack(spacing: 20) {
					VStack(spacing: 2) {
						let startTime: String = TimeFormatter.getTime(date: viewModel.order.startTimeDate)
						let endTime: String = TimeFormatter.getTime(date: viewModel.order.endTimeDate)
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
					compactView()
						.padding(8)
						.background(CardBackground())
				}
				.padding(.horizontal)
			}
		}
		.alert(
			isPresented: Binding(
				get: { viewModel.action != nil } ,
				set: { _ in viewModel.resetAlert() }
		)
		) {
			if let alert = viewModel.action {
				let title: String = alert.rawValue.capitalized
				return Alert(
					title: Text("Are you sure you want to \"\(title)\" this reservation?"),
					message: Text("This action is not reversible"),
					primaryButton: alert == .decline ? .destructive(Text("\(title)")) : .default(Text("\(title)")) {
						switch alert {
						case .decline: viewModel.declineOrder()
						case .approve: viewModel.approveOrder()
						case .complete: viewModel.completeOrder()
						}
					},
					secondaryButton: .cancel()
				)
			}
			return Alert(title: Text("Something went wrong"))
		}
		.sheet(isPresented: $viewModel.isShowingCustomerCard) {
			CustomerView(customer: viewModel.order.customer, context: .detail)
		}
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
				Text("$\(PriceFormatter.price(value: String(viewModel.orderAmount)))")
					.font(Font.app.body)
					.foregroundColor(viewModel.order.payment == nil ? Color.app.tertiaryText : Color.app.accent)
				HStack(spacing: 6) {
					Button(action: { viewModel.openCustomerView() }) {
						Text(customerName())
							.foregroundColor(Color.app.primaryText)
							.underline()
							.lineLimit(1)
					}
					timeView()
					Spacer(minLength: 0)
					Image(systemName: "doc.text")
						.font(.system(size: FontSizes.title3, weight: .semibold))
				}
				.font(Font.app.body)
				.foregroundColor(Color.app.tertiaryText)
			}
		}
	}
	
	@ViewBuilder
	func title(_ content: String) -> some View {
		Text(content)
			.font(Font.app.footnote)
			.foregroundColor(Color.app.tertiaryText)
			.lineLimit(1)
	}
	
	@ViewBuilder
	func label(_ content: String) -> some View {
		Text(content)
			.font(Font.app.bodySemiBold)
			.foregroundColor(Color.app.primaryText)
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
		if let note = viewModel.order.note {
			Text(note)
				.font(Font.app.body)
				.foregroundColor(Color.app.primaryText)
				.padding()
				.background(CardBackground())
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
			case .pending, .approved:
				Divider()
					.padding(.vertical)
			case .declined, .completed:
				EmptyView()
			}
			HStack {
				Spacer()
				HStack(spacing: 10) {
					switch orderStatus {
					case .pending:
						declineButton()
						approveButton()
					case .approved:
						declineButton()
						completeButton()
					case .declined, .completed:
						EmptyView()
					}
				}
			}
		}
	}
	
	@ViewBuilder
	func approveButton() -> some View {
		button(isProminent: true, symbol: "checkmark", title: "Approve") {
			viewModel.requestAction(action: .approve)
		}
	}
	
	@ViewBuilder
	func declineButton() -> some View {
		button(isProminent: false, symbol: "xmark", title: "Decline") {
			viewModel.requestAction(action: .decline)
		}
	}
	
	@ViewBuilder
	func completeButton() -> some View {
		button(isProminent: false, symbol: "checkmark", title: "Complete") {
			viewModel.requestAction(action: .complete)
		}
	}
	
	@ViewBuilder
	func button(isProminent: Bool, symbol: String, title: String, action: @escaping () -> ()) -> some View {
		let foregroundColor: Color = isProminent ? Color.app.secondaryText : Color.app.primaryText
		let cardStyle: CardBackground.Style = isProminent ? .black : .white
		Button(action: { action() }) {
			HStack {
				Image(systemName: symbol)
				Text(title)
			}
			.font(Font.app.bodySemiBold)
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
			let startDate: Date = ServerDateFormatter.formatToDate(from: order.startTime)
			let endDate: Date = ServerDateFormatter.formatToDate(from: order.endTime)
			if Date.now.isBetween(startDate, and: endDate) {
				return nowText
			} else {
				return startDate.timeAgoDisplay()
			}
		}()
		Text(" •  \(timeDisplay) ")
			.font(Font.app.body)
			.foregroundColor(timeDisplay == nowText ? Color.app.accent : Color.app.tertiaryText)
	}
	
	func formattedTime() -> String {
		let date: Date = viewModel.order.startTimeDate
		let components = Calendar.current.dateComponents([.month, .day, .weekday], from: date)
		
		let time: String = TimeFormatter.getTime(date: date)
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
		let timeComponents: DateComponents = Calendar.current.dateComponents([.hour, .minute], from: viewModel.order.startTimeDate, to: viewModel.order.endTimeDate)
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
		OrderView(viewModel: .init(context: .detail, order: Order.mock1))
		OrderView(viewModel: .init(context: .detail, order: Order.mock2))
		OrderView(viewModel: .init(context: .dashboard, order: Order.mock2))
		VStack {
			Spacer()
			OrderView(viewModel: .init(context: .calendar, order: Order.mock2))
			Spacer()
		}
		.background(Color.app.secondaryBackground)
	}
}
