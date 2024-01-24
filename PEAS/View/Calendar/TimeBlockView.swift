//
//  TimeBlockView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2024-01-24.
//

import SwiftUI

struct TimeBlockView: View {
	enum Context {
		case add
		case edit
	}
	
	let context: Context
	let canSaveChanges: Bool
	let onDelete: () -> ()
	let onSave: () -> ()
	
	var title: Binding<String>
	var startTime: Binding<Date>
	var endTime: Binding<Date>
	
	var isEditingAllowed: Bool {
		switch context {
		case .add: return true
		case .edit: return false
		}
	}
	
	init(
		context: Context,
		canSaveChanges: Bool,
		title: Binding<String>,
		startTime: Binding<Date>,
		endTime: Binding<Date>,
		onDelete: @escaping () -> (),
		onSave: @escaping () -> ()
	) {
		self.context = context
		self.canSaveChanges = canSaveChanges
		self.title = title
		self.startTime = startTime
		self.endTime = endTime
		self.onDelete = onDelete
		self.onSave = onSave
	}
	
	var body: some View {
		VStack(spacing: 0) {
			SheetHeaderView(title: "Block Time")
			VStack {
				VStack {
					HStack {
						subTitleText("Title")
						Spacer()
					}
					.padding(.top)
					TextField("e.g Vacation with besties", text: title.max(60))
						.submitLabel(.done)
						.font(Font.app.bodySemiBold)
						.foregroundColor(Color.app.primaryText)
						.padding(.horizontal)
						.padding(.vertical, 12)
						.tint(Color.app.primaryText)
						.background(CardBackground())
						.disabled(!isEditingAllowed)
				}
				.disabled(!isEditingAllowed)
				.opacity(isEditingAllowed ? 1.0 : 0.5)
				.padding(.horizontal, SizeConstants.horizontalPadding)
				VStack(alignment: .leading) {
					subTitleText("From:")
					DateTimePicker(context: .dayAndTime, date: startTime)
					subTitleText("To:")
						.padding(.top)
					DateTimePicker(context: .dayAndTime, date: endTime)
					Spacer(minLength: 0)
					HStack {
						Spacer(minLength: 0)
						Text("\(endTime.wrappedValue.getTimeSpan(from: startTime.wrappedValue).timeSpan)")
							.font(Font.app.title2)
							.foregroundStyle(Color.app.primaryText)
						Spacer(minLength: 0)
					}
					Spacer(minLength: 0)
				}
				.disabled(!isEditingAllowed)
				.opacity(isEditingAllowed ? 1.0 : 0.5)
				.padding(.horizontal, SizeConstants.horizontalPadding)
				.padding(.top)
				Group {
					if isEditingAllowed {
						Button(action: { onSave() }) {
							Text("Save")
						}
					} else {
						Button(action: { onDelete() }) {
							Text("Delete")
						}
					}
				}
				.buttonStyle(.expanded)
				.padding(.horizontal, 10)
				.disabled(!canSaveChanges)
				.padding(.bottom)
			}
			.background(Color.app.secondaryBackground)
		}
	}
	
	@ViewBuilder
	func subTitleText(_ content: String) -> some View {
		Text(content)
			.font(Font.system(size: 16, weight: .semibold, design: .rounded))
			.foregroundColor(Color.app.tertiaryText)
	}
}

#Preview {
	TimeBlockView(
		context: .edit,
		canSaveChanges: true,
		title: Binding.constant("Home Sweet Home"),
		startTime: Binding.constant(Date.now),
		endTime: Binding.constant(Date.now),
		onDelete: {},
		onSave: {}
	)
}
