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
			HStack {
				image()
				VStack(alignment: .leading, spacing: 4) {
					HStack {
						label(viewModel.order.title)
						Spacer(minLength: 0)
						statusBadge()
					}
					Text("$\(PriceFormatter.price(value: String(viewModel.orderAmount)))")
						.font(Font.app.body)
						.foregroundColor(viewModel.order.payment == nil ? Color.app.tertiaryText : Color.app.accent)
					HStack(spacing: 6) {
						Button(action: { viewModel.openCustomerView() }) {
							Text(customerName())
								.foregroundColor(Color.app.primaryText)
								.underline()
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
		case .calendar:
			EmptyView()
		}
	}
	
	@ViewBuilder
	func title(_ content: String) -> some View {
		Text(content)
			.font(Font.app.footnote)
			.foregroundColor(Color.app.tertiaryText)
	}
	
	@ViewBuilder
	func label(_ content: String) -> some View {
		Text(content)
			.font(Font.app.bodySemiBold)
			.foregroundColor(Color.app.primaryText)
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
			viewModel.approveOrder()
		}
	}
	
	@ViewBuilder
	func declineButton() -> some View {
		button(isProminent: false, symbol: "xmark", title: "Decline") {
			viewModel.declineOrder()
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
		let startDate: Date = ServerDateFormatter.formatToDate(from: order.startTime)
		let endDate: Date = ServerDateFormatter.formatToDate(from: order.endTime)
		
		let timeDisplay: String = {
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
		let date: Date = ServerDateFormatter.formatToLocal(from: viewModel.order.startTime)
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
	
	func customerName() -> String {
		return "\(viewModel.order.customer.firstName) \(viewModel.order.customer.lastName)"
	}
}

struct OrderView_Previews: PreviewProvider {
	static var previews: some View {
		OrderView(viewModel: .init(context: .detail, order: Order.mock1))
		OrderView(viewModel: .init(context: .detail, order: Order.mock2))
		OrderView(viewModel: .init(context: .dashboard, order: Order.mock2))
	}
}
