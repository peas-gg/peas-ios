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
						Text("$\(PriceFormatter.price(value: String(viewModel.order.price)))")
							.font(Font.app.largeTitle)
							.foregroundColor(Color.app.primaryText)
					}
					VStack(alignment: alignment) {
						title("Customer:")
						Button(action: {}) {
							let customer: Customer = viewModel.order.customer
							label("\(customer.firstName) \(customer.lastName)")
								.underline()
						}
					}
					VStack(alignment: alignment) {
						title("Time & Date:")
						label("\(formattedTime())")
					}
				}
			}
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
	
	func formattedTime() -> String {
		let date: Date = ServerDateFormatter.formatToLocal(from: viewModel.order.startTime)
		let components = Calendar.current.dateComponents([.month, .day, .weekday,], from: date)
		
		let time: String = TimeFormatter.getTime(date: date)
		let weekDay: String = {
			if let weekDay = components.weekday {
				return calendarClient.weekDaysShort[weekDay]
			}
			return ""
		}()
		let month: String = {
			if let month = components.month {
				return calendarClient.monthFormatter.shortMonthSymbols[month]
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
	
}

struct OrderView_Previews: PreviewProvider {
	static var previews: some View {
		OrderView(viewModel: .init(context: .detail, order: Order.mock1))
	}
}
