//
//  WelcomeView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-01.
//

import SwiftUI

struct WelcomeView: View {
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		
		ZStack {
			/*
			AngularGradient(
				gradient: Gradient(colors: [
					Color(#colorLiteral(red: 0, green: 0.337254902, blue: 0.337254902, alpha: 1)),
					Color(#colorLiteral(red: 0.368627451, green: 0.6509803922, blue: 0.8078431373, alpha: 1)),
					Color(#colorLiteral(red: 0.3803921569, green: 0.8274509804, blue: 0.7450980392, alpha: 1)),
					Color(#colorLiteral(red: 0.6470588235, green: 0.9411764706, blue: 0.9843137255, alpha: 1))
				]),
				center: .center)
			
			.ignoresSafeArea()
			*/
			
			HStack{
				VStack{
					
					LinearGradient(
						gradient: Gradient(colors: [
							Color(#colorLiteral(red: 0, green: 0.337254902, blue: 0.337254902, alpha: 1))
							//Color(red: 0, green: 0.337254902, blue: 0.337254902),
							//Color(red: 0.368627451, green: 0.6509803922, blue: 0.8078431373)
						]),
						startPoint: .topLeading,
						endPoint: .bottomLeading
					)
					LinearGradient(
						gradient: Gradient(colors: [
							Color(#colorLiteral(red: 0.368627451, green: 0.6509803922, blue: 0.8078431373, alpha: 1))
							//Color(red: 0.368627451, green: 0.6509803922, blue: 0.8078431373),
							//Color(red: 0.6470588235, green: 0.9411764706, blue: 0.9843137255),
							//Color(red: 0.3803921569, green: 0.8274509804, blue: 0.7450980392)
						]),
						startPoint: .topTrailing,
						endPoint: .bottomTrailing
					)
					
				}
				
				Spacer()
				
				VStack{
					
					LinearGradient(
						gradient: Gradient(colors: [
							Color(#colorLiteral(red: 0.6470588235, green: 0.9411764706, blue: 0.9843137255, alpha: 1)),
						]),
						startPoint: .topLeading,
						endPoint: .bottomLeading
					)
					LinearGradient(
						gradient: Gradient(colors: [
							Color(#colorLiteral(red: 0.3803921569, green: 0.8274509804, blue: 0.7450980392, alpha: 1))
						]),
						startPoint: .topTrailing,
						endPoint: .bottomTrailing
					)
					
				}
				
			}
			.ignoresSafeArea()
			.blur(radius: 40)
			
			VStack{
			
					LinearGradient(
						gradient: Gradient(colors: [
							Color(red: 0, green: 0.337254902, blue: 0.337254902),
							//Color(red: 0.368627451, green: 0.6509803922, blue: 0.8078431373)
						]),
						startPoint: .topLeading,
						endPoint: .bottomLeading
					)
					LinearGradient(
						gradient: Gradient(colors: [
							Color(red: 0.368627451, green: 0.6509803922, blue: 0.8078431373),
							//Color(red: 0.6470588235, green: 0.9411764706, blue: 0.9843137255),
							//Color(red: 0.3803921569, green: 0.8274509804, blue: 0.7450980392)
						]),
						startPoint: .topTrailing,
						endPoint: .bottomTrailing
					)
				
			}
			.ignoresSafeArea()
			.blur(radius: 40)
			
			
			RadialGradient(
				gradient: Gradient(colors: [
					//Color.black,
					.clear,
					Color.black
				]),
				center: UnitPoint(x: 0.5, y: 0.3),
				startRadius: 0,
				endRadius: 300
			)
			.ignoresSafeArea()
			
			VStack (alignment: .center){
				Spacer()
				Button(action: { viewModel.startOnboarding() }) {
					Text("Start")
				}
				.padding()
			}
			// Your content here
		}
		
		
	}
}

struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView(viewModel: .init(onboardingVM: .init()))
	}
}
