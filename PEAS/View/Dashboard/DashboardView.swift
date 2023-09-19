//
//  DashboardView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct DashboardView: View {
	@StateObject var viewModel: ViewModel
	@State private var isShowingFilter = false
	@State private var selectedFilter: FilterButtonView.Filter?
	@State private var isUserViewPresented = false
	
	struct Service: Identifiable {
		let id = UUID()
		let imageUrl: String
		let name: String
		let price: String
		let status: String
	}
	enum StatusColor: String, CaseIterable, Identifiable {
		case approved
		case pending
		case completed
		case declined
		
		var id: String{
			self.rawValue
		}
		var rectanglecolor: Color{
			switch self {
					case .approved: return Color(UIColor(hex: "#F3FAF2"))
					case .pending: return Color(UIColor(hex: "#FCF7C9"))
					case .completed: return Color(UIColor(hex: "#F8F8F8"))
					case .declined: return Color(UIColor(hex: "#FAF2F2"))
					}
		}
		var textColor: Color {
			   switch self {
			   case .approved: return Color(UIColor(hex: "#2BA72A"))
			   case .pending: return Color(UIColor(hex: "#A79A2A"))
			   case .completed: return Color(UIColor(hex: "#858585"))
			   case .declined: return Color(UIColor(hex: "#A72A2A"))
			   }
		   }
	}
	
	let url = URL(string: "https://en.gravatar.com/userimage/238873705/657a6a16307fd0a8c47e1d7792173277.jpeg?size=256")!
	
	let services: [Service] = [
		Service(imageUrl:"https://en.gravatar.com/userimage/238873705/657a6a16307fd0a8c47e1d7792173277.jpeg?size=256", name: "Sweet cut", price: "$300", status: "PENDING"),
		Service(imageUrl:"https://en.gravatar.com/userimage/238873705/657a6a16307fd0a8c47e1d7792173277.jpeg?size=256", name: "Sweet cut", price: "$300", status: "DECLINED"),
		Service(imageUrl:"https://en.gravatar.com/userimage/238873705/161389d4185bdba59229b83175ac5cb0.jpeg?size=256", name: "Fire fist", price: "$250", status: "APPROVED"), Service(imageUrl:"https://en.gravatar.com/userimage/238873705/657a6a16307fd0a8c47e1d7792173277.jpeg?size=256", name: "Sweet cut", price: "$300", status: "PENDING"), Service(imageUrl:"https://en.gravatar.com/userimage/238873705/161389d4185bdba59229b83175ac5cb0.jpeg?size=256", name: "Fire fist", price: "$250", status: "COMPLETED"),
		Service(imageUrl:"https://en.gravatar.com/userimage/238873705/161389d4185bdba59229b83175ac5cb0.jpeg?size=256", name: "Fire fist", price: "$250", status: "COMPLETED"),
		Service(imageUrl:"https://en.gravatar.com/userimage/238873705/161389d4185bdba59229b83175ac5cb0.jpeg?size=256", name: "Fire fist", price: "$250", status: "COMPLETED"),
		// Service(name: "Service 2", status: "Approved"),
		//Service(name: "Service 3", status: "Completed")
	]
	
	var body: some View {
		VStack {
			HStack {
				VStack (alignment: .leading){
					Text("Welcome,")
						.foregroundColor(Color.app.tertiaryText)
					Text("Melissa")
						.foregroundColor(Color.app.primaryText)
				}
				.font(.system(size: FontSizes.title1, weight: .semibold, design: .rounded))
				.padding()
				Spacer()
				
				Button(action: {
					isUserViewPresented.toggle()
				}) {
					CachedAvatar(url: url, height: 60)
						.padding()
				}
				.sheet(isPresented: $isUserViewPresented) {
					UserView(viewModel: UserView.ViewModel(user: User.mock1))
				}
				
			}
			.padding(.horizontal)
			.padding(.top)
			Spacer().frame(height: 20)
			Text("$2,378.56")
				.foregroundColor(.green)
				.font(.system(size: 50, weight: .semibold, design: .rounded))
				.padding(-1)
			HStack{
				Button(action: {}) {
					HStack(spacing: -4) {
						Image(systemName: "dollarsign.circle")
						Text("CashOut")
							.font(.system(size: FontSizes.title2, weight: .semibold, design: .rounded))
							.foregroundColor(Color.app.primaryText)
							.padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
					}
					.padding(5)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.white)
					)
				}
				Button(action: {}) {
					HStack(spacing: -4) {
						Image(systemName: "doc.text")
						
						Text("Transcations")
							.font(.system(size: FontSizes.title2, weight: .semibold, design: .rounded))
							.foregroundColor(Color.app.primaryText)
							.padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
					}
					.padding(5)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.white)
					)
				}
			}
			.padding()
			ZStack (alignment: .topTrailing){
				VStack(spacing: 0){
					HStack {
						Text("Services (7 pending)")
							.font(.headline)
							.padding()
						Spacer()
						if let selectedFilter{
							FilterButtonView.IndicatorView(filter: selectedFilter)
						}
						Button(action: {
							isShowingFilter.toggle()
						}) {
							Image(systemName: selectedFilter == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
								.font(.system(size: 24)) // Adjust font size
								.frame(width: 30, height: 30) // Adjust button size
						}
						.padding(.trailing)
					}
					.background{
						CustomRoundedRectangle(cornerRadius: 10, corners: [.topLeft, .topRight])
							.fill(Color.white)
					}
					Rectangle()
						.fill(Color.gray)
						.frame(height: 0.5)
						.padding(.horizontal)
					VStack{
						ScrollView {
							LazyVStack {
								ForEach(services) { service in
									HStack {
										HStack() {
											CachedImage(
												url: URL(string: service.imageUrl)!,
												content: { uiImage in
													Image(uiImage: uiImage)
														.resizable()
														.frame(width: 50, height: 60)
														.scaledToFill()
														.clipShape(RoundedRectangle(cornerRadius: 20))
												},
												placeHolder: {
													RoundedRectangle(cornerRadius: 20)
														.fill(Color.gray)
												}
											)
											VStack(alignment: .leading){
												HStack {
													Text(service.name)
														.font(.headline)
													
													Spacer()
													
													Text(service.status)
														.font(.system(size: 10))
														.foregroundColor(StatusColor(rawValue: service.status.lowercased())?.textColor ?? .clear)
														.padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
														.background{
															RoundedRectangle(cornerRadius: 4)
																.fill(StatusColor(rawValue: service.status.lowercased())?.rectanglecolor ?? .clear)
														}
												}
												Text(service.price)
													.foregroundColor(Color.app.tertiaryText)
											}
										}
									}
								}
							}
							
						}
						.padding(.top)
						.padding(.horizontal, 30)
					}
					.background(Color.white)
					.overlay (alignment: .topTrailing){}
				}
				.padding(.horizontal)
				if isShowingFilter {
					VStack(alignment: .leading) {
						VStack(alignment: .leading) {
							ForEach(FilterButtonView.Filter.allCases) { filter in
								FilterButtonView(filter: filter, action: {
									if selectedFilter ==  filter {
										self.selectedFilter = nil
									}
									else {
										self.selectedFilter = filter
									}
									self.isShowingFilter = false
								})
							}
						}
						.frame(maxWidth: 190)
					}
					.padding()
					.background {
						ZStack {
							RoundedRectangle(cornerRadius: 10)
								.fill(Color.white)
							RoundedRectangle(cornerRadius: 10)
								.stroke(Color(uiColor: UIColor(hex: "E5E5E5")))
						}
					}
					.padding(50)
					.padding(.trailing, -10)
				}
			}
		}
		.foregroundColor(Color.app.primaryText)
		.background(Color(uiColor: UIColor(hex: "F4F4F6")))
	}
}

struct DashboardView_Previews: PreviewProvider {
	static var previews: some View {
		DashboardView(viewModel: .init())
	}
}

struct CustomRoundedRectangle: Shape {
	let cornerRadius: CGFloat
	let corners: UIRectCorner
	
	public func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(
			roundedRect: rect,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
		)
		return Path(path.cgPath)
	}
}
struct FilterButtonView: View {
	enum Filter: String, CaseIterable, Identifiable {
		case Approved
		case Pending
		case Completed
		case Declined
		var opacity: Double {
			0.1
		}
		var id: String {
			self.rawValue
		}
		var color: Color {
			switch self {
			case .Approved: return Color.green.opacity(opacity)
			case .Pending: return Color.yellow.opacity(opacity)
			case .Completed: return Color.gray.opacity(opacity)
			case .Declined: return Color.red.opacity(opacity)
			}
		}
		var strokeColor: Color {
			switch self {
			case .Approved: return Color.green
			case .Pending: return Color.yellow
			case .Completed: return Color.gray
			case .Declined: return Color.red
			}
		}
	}
	struct IndicatorView: View {
		let filter: Filter
		var body: some View {
			ZStack {
				Circle()
					.fill(filter.color)
				Circle()
					.stroke(filter.strokeColor)
			}
			.frame(dimension: 20)
		}
	}
	let filter: Filter
	var action: () -> ()
	var body: some View {
		Button(action: {
			action()
		}) {
			HStack(spacing: 25) {
				Text(filter.rawValue)
					.foregroundColor(Color.black)
				Spacer()
				IndicatorView(filter: filter)
			}
		}
	}
}
