//
//  DashboardView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct DashboardView: View {
	@StateObject var viewModel: ViewModel
    let url = URL(string: "https://en.gravatar.com/userimage/238873705/657a6a16307fd0a8c47e1d7792173277.jpeg?size=256")
    
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
                Spacer()
                
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let returnImage):
                        returnImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            //.clipShape(Circle())
                            .cornerRadius(30)
                    case .failure:
                        Image(systemName: "questionmark")
                            .font(.headline)
                    default:
                        Image(systemName: "questionmark")
                            .font(.headline)
                    }
                }
                
            }
            .padding(.horizontal)
            .padding(.top)
            Spacer().frame(height: 30)
            Text("$2,378.56")
                .foregroundColor(.green)
                .font(.system(size: 50, weight: .semibold, design: .rounded))
            
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
