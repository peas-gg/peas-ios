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
	
	let url = URL(string: "https://en.gravatar.com/userimage/238873705/657a6a16307fd0a8c47e1d7792173277.jpeg?size=256")
	
	let services: [Service] = [
		Service(imageUrl:"https://en.gravatar.com/userimage/238873705/657a6a16307fd0a8c47e1d7792173277.jpeg?size=256", name: "Sweet cut", price: "$300", status: "Pending"),
		Service(imageUrl:"https://en.gravatar.com/userimage/238873705/161389d4185bdba59229b83175ac5cb0.jpeg?size=256", name: "Fire fist", price: "$250", status: "Pending"),
		Service(imageUrl:"https://en.gravatar.com/userimage/238873705/161389d4185bdba59229b83175ac5cb0.jpeg?size=256", name: "Fire fist", price: "$250", status: "Approved"),
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
							.scaledToFit()
							.frame(width: 50, height: 60)
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
			
			List(services){
				service in
				HStack {
					HStack() {
						AsyncImage(url: URL(string: service.imageUrl)) { phase in
							switch phase {
							case .empty:
								ProgressView()
							case .success(let returnImage):
								returnImage
									.resizable()
									.scaledToFit()
									.frame(width: 50, height: 60)
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
									.font(.headline)
								
							}
							
							Text(service.price)
								.foregroundColor(Color.app.tertiaryText)
							
						}
						
						
					}
				}
			}
			
			Spacer()
		}
		.foregroundColor(Color.app.primaryText)
		.background(Color.app.primaryBackground)
		
	}
	
}

struct DashboardView_Previews: PreviewProvider {
	static var previews: some View {
		DashboardView(viewModel: .init())
	}
}
