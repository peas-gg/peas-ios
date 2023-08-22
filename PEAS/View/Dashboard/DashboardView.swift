//
//  DashboardView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct DashboardView: View {
	@StateObject var viewModel: ViewModel
	
	struct Service: Identifiable {
		let id = UUID()
		let imageUrl: String
		let name: String
		let price: String
		let status: String
		
	}
	
	func getStatusColor(for status: String) -> Color {
		switch status {
		case "APPROVED":
			return Color(UIColor(hex: "#F3FAF2"))
		case "PENDING":
			return Color(UIColor(hex: "#FCF7C9"))
		case "COMPLETED":
			return Color(UIColor(hex: "#F8F8F8"))
		case "DECLINED":
			return Color(UIColor(hex: "#FAF2F2"))
		default:
			return Color.clear
		}
	}
	func getTextColor(for status: String) -> Color {
		switch status {
		case "APPROVED":
			return Color(UIColor(hex: "#2BA72A"))
		case "PENDING":
			return Color(UIColor(hex: "#A79A2A"))
		case "COMPLETED":
			return Color(UIColor(hex: "#858585"))
		case "DECLINED":
			return Color(UIColor(hex: "#A72A2A"))
		default:
			return Color.clear
		}
	}
	
	let url = URL(string: "https://en.gravatar.com/userimage/238873705/657a6a16307fd0a8c47e1d7792173277.jpeg?size=256")
	
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
				
				AsyncImage(url: url) { phase in
					switch phase {
					case .empty:
						ProgressView()
					case .success(let returnImage):
						returnImage
							.resizable()
							.frame(width: 50, height: 60)
							.scaledToFit()
							.clipShape(RoundedRectangle(cornerRadius: 20))
						//cornerRadius(30)
					case .failure:
						Image(systemName: "questionmark")
							.font(.headline)
					default:
						Image(systemName: "questionmark")
							.font(.headline)
					}
				}
				.padding()
				
			}
			.padding(.horizontal)
			.padding(.top)
			Spacer().frame(height: 30)
			Text("$2,378.56")
				.foregroundColor(.green)
				.font(.system(size: 50, weight: .semibold, design: .rounded))
			
			VStack(spacing: 0){
				HStack {
					Text("Services (7 pending)")
						.font(.headline)
						.padding()
					Spacer()
					Button(action: {
						// Add sorting action
					}) {
						Image(systemName: "line.3.horizontal.decrease.circle")
							.font(.system(size: 24)) // Adjust font size
							.frame(width: 30, height: 30) // Adjust button size
					}
					.padding()
					
				}
				.background{
					CustomRoundedRectangle(cornerRadius: 10, corners: [.topLeft, .topRight])
						.fill(Color.white)
				}
				Rectangle()
					.fill(Color.gray)
					.frame(height: 0.2)
					.padding(.horizontal)
				
				VStack{
					ScrollView {
						LazyVStack {
							ForEach(services) { service in
								HStack {
									HStack() {
										AsyncImage(url: URL(string: service.imageUrl)) { phase in
											switch phase {
											case .empty:
												ProgressView()
											case .success(let returnImage):
												returnImage
													.resizable()
													.frame(width: 50, height: 60)
													.scaledToFill()
													.clipShape(RoundedRectangle(cornerRadius: 20))
												//cornerRadius(30)
											case .failure:
												Image(systemName: "questionmark")
													.font(.headline)
											default:
												Image(systemName: "questionmark")
													.font(.headline)
											}
										}
										
										VStack(alignment: .leading){
											HStack {
												Text(service.name)
													.font(.headline)
												
												Spacer()
												
												Text(service.status)
													.font(.system(size: 10))
													.foregroundColor(getTextColor(for: service.status))
													.padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
													.background{
														RoundedRectangle(cornerRadius: 4)
															.fill(getStatusColor(for: service.status))
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
				
			}
			.padding(.horizontal)
			/*
			 .background {
			 ZStack {
			 let cornerRadius: CGFloat = 10
			 CustomRoundedRectangle(cornerRadius: cornerRadius, corners: [.topLeft, .topRight])
			 .fill(Color.white)
			 CustomRoundedRectangle(cornerRadius: cornerRadius, corners: [.topLeft, .topRight])
			 .stroke(Color(uiColor: UIColor(hex: "E5E5E5")))
			 }
			 .padding(.horizontal, 10)
			 }
			 */
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
