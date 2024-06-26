//
//  CalendarView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct CalendarView: View {
	let yOffsetPadding: CGFloat = 200
	
	let timeBlockFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "(h:mma)  DD MMM"
		return dateFormatter
	}()
	
	@StateObject var viewModel: ViewModel
	
	@State var yOffset: CGFloat
	
	init(viewModel: ViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
		self._yOffset = State(initialValue: SizeConstants.screenSize.height - yOffsetPadding)
	}
	
	var body: some View {
		NavigationStack(path: $viewModel.navStack) {
			ZStack {
				VerticalTabView(selectionValue: $viewModel.selectedDateIndex, hasOffset: yOffset > 0) {
					ForEach(0..<viewModel.months.count, id: \.self) {
						monthsView(currentIndex: $0)
							.tag($0 / 2)
					}
					.tint(Color.clear)
					.opacity(viewModel.isExpanded ? 1.0 : 0.0)
					.animation(.easeInOut, value: viewModel.isExpanded)
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.background(Color.app.accent.edgesIgnoringSafeArea(.top))
				.offset(y: -yOffset)
				.animation(.linear.speed(2.0), value: yOffset)
				VStack(spacing: 0) {
					MonthView(
						month: viewModel.selectedDate,
						selectedDate: viewModel.selectedDate,
						isCollapsed: true,
						daysToHighlight: viewModel.daysWithEvents
					) { date in
						self.viewModel.dateSelected(date: date)
					}
					.padding(.bottom)
					.background(Color.app.accent.edgesIgnoringSafeArea(.top))
					ScrollView {
						LazyVStack {
							ForEach(viewModel.currentShowingEvents) { calendarEvent in
								Group {
									switch calendarEvent.event {
									case .order(let order):
										Button(action: { viewModel.pushStack(.order(order)) }) {
											OrderView(
												viewModel: OrderView.ViewModel(
													context: .calendar,
													business: viewModel.business,
													order: order
												)
											)
										}
									case .timeBlock(let timeBlock):
										Button(action: { viewModel.timeBlockTapped(timeBlock) }) {
											timeBlockMiniView(timeBlock)
										}
									}
								}
								.buttonStyle(.plain)
								.padding(.bottom, 20)
							}
						}
						.padding(.top, 40)
						.padding(.bottom, SizeConstants.scrollViewBottomPadding + 20)
					}
					Spacer(minLength: 0)
				}
				.opacity(viewModel.isExpanded ? 0.0 : 1.0)
				.animation(.linear.speed(4.0), value: viewModel.isExpanded)
			}
			.overlay(alignment: .topTrailing) {
				Button(action: {
					viewModel.setSelectedDateIndex()
					withAnimation(.default) {
						self.viewModel.isExpanded.toggle()
					}
				}) {
					Image(systemName: "chevron.down.circle.fill")
						.font(Font.app.largeTitle)
						.foregroundColor(Color.white)
						.rotationEffect(viewModel.isExpanded ? .degrees(180) : .degrees(0))
						.animation(.easeInOut, value: viewModel.isExpanded)
				}
				.padding(.trailing)
			}
			.overlay(alignment: .bottomTrailing) {
				Button(action: { viewModel.addNewTimeBlock() }) {
					Image(systemName: "plus")
						.font(Font.app.largeTitle)
						.foregroundColor(Color.app.accent)
						.padding()
						.background {
							ZStack {
								Circle()
									.fill(Color.app.primaryBackground)
								Circle()
									.stroke(Color.gray.opacity(0.2), lineWidth: 1)
							}
						}
						.shadow(color: Color.gray.opacity(0.2), radius: 2, x: 1, y: 2)
				}
				.buttonStyle(.insideScaling)
				.opacity(viewModel.isExpanded ? 0.0 : 1.0)
				.animation(.easeIn.speed(2.0), value: viewModel.isExpanded)
				.padding([.bottom, .trailing], 30)
			}
			.navigationTitle("")
			.navigationDestination(for: ViewModel.Route.self) { route in
				Group {
					switch route {
					case .order(let order):
						OrderView(viewModel: OrderView.ViewModel(context: .detail, business: viewModel.business, order: order))
					}
				}
				.navigationBarTitleDisplayMode(.inline)
			}
			.sheet(
				item: $viewModel.sheet,
				onDismiss: {},
				content: { sheet in
					Group {
						switch sheet {
						case .timeBlock:
							TimeBlockView(
								context: viewModel.timeBlockContext,
								canSaveChanges: viewModel.canSaveTheBlockedTime,
								title: $viewModel.timeBlockTitle,
								startTime: $viewModel.timeBlockStartTime,
								endTime: $viewModel.timeBlockEndTime,
								onDelete: { viewModel.onDeleteTimeBlock() },
								onSave: { viewModel.onSaveTimeBlock() }
							)
						}
					}
					.progressView(isShowing: viewModel.isProcessingSheetRequest, style: .black)
					.banner(data: $viewModel.sheetBannerData)
					.alert(isPresented: $viewModel.isShowingTimeBlockDeleteAlert) {
						Alert(
							title: Text("Are you sure you want to delete this time block?"),
							message: Text("You cannot undo this. The blocked time will be deleted from your calendar."),
							primaryButton: .destructive(Text("Delete")) {
								viewModel.deleteTimeBlock()
							},
							secondaryButton: .cancel()
						)
					}
				}
			)
			.onAppear { self.viewModel.didAppear() }
			.onChange(of: self.viewModel.selectedDate) { _ in
				self.viewModel.setSelectedDateIndex()
			}
			.onChange(of: viewModel.isExpanded) { _ in
				setYOffset()
			}
		}
	}
	
	@ViewBuilder
	func timeBlockMiniView(_ timeBlock: TimeBlock) -> some View {
		HStack(spacing: 8) {
			let size: CGSize = CGSize(width: 50, height: 70)
			let cornerRadius: CGFloat = 6
			RoundedRectangle(cornerRadius: cornerRadius)
				.fill(Color.app.accent.opacity(0.6))
				.frame(size: size)
				.overlay {
					Image(systemName: "slash.circle")
						.font(Font.app.title1)
						.foregroundStyle(Color.app.darkGreen)
				}
			VStack(alignment: .leading, spacing: 8) {
				Text(timeBlock.title)
					.font(Font.app.bodySemiBold)
					.foregroundStyle(Color.app.primaryText)
					.lineLimit(1)
				HStack {
					Text("Blocked Time")
						.foregroundStyle(Color.app.primaryText)
					Spacer(minLength: 0)
				}
				HStack {
					Text("\(self.timeBlockFormatter.string(from: timeBlock.startTimeDate))")
					Image(systemName: "ellipsis")
						.font(Font.app.title2)
						.padding(.horizontal)
					Text("\(self.timeBlockFormatter.string(from: timeBlock.endTimeDate))")
				}
				.foregroundStyle(Color.app.tertiaryText)
			}
			.font(Font.app.caption)
		}
		.padding(6)
		.background(CardBackground())
		.padding(.horizontal)
	}
	
	@ViewBuilder
	func monthsView(currentIndex: Int) -> some View {
		let nextIndex = currentIndex + 1
		if currentIndex % 2 == 0 || currentIndex == 0 {
			VStack {
				MonthView(
					month: viewModel.months[currentIndex],
					selectedDate: viewModel.selectedDate,
					daysToHighlight: viewModel.daysWithEvents
				) { date in
					viewModel.dateSelected(date: date)
				}
				Spacer()
				if nextIndex < viewModel.months.count {
					MonthView(
						month: viewModel.months[nextIndex],
						selectedDate: viewModel.selectedDate,
						daysToHighlight: viewModel.daysWithEvents
					) { date in
						viewModel.dateSelected(date: date)
					}
					Spacer()
				}
			}
		}
	}
	
	@ViewBuilder
	func subTitleText(_ content: String) -> some View {
		Text(content)
			.font(Font.system(size: 16, weight: .semibold, design: .rounded))
			.foregroundColor(Color.app.tertiaryText)
	}
	
	func setYOffset() {
		if viewModel.isExpanded {
			yOffset = 0
		} else {
			yOffset = SizeConstants.screenSize.height - yOffsetPadding
		}
	}
}

struct CalendarView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			CalendarView(
				viewModel: .init(
					business: Business.mock1,
					orders: [
						Order.mock1,
						Order.mock2,
						Order.mock3,
						Order.mock4,
						Order.mock5,
						Order.mock6,
						Order.mock7,
						Order.mock8
					],
					timeBlocks: [TimeBlock.mock1]
				)
			)
		}
	}
}
