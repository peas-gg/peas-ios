//
//  DashboardView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-08-11.
//

import SwiftUI

struct DashboardView: View {
	@StateObject var viewModel: ViewModel
	
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
