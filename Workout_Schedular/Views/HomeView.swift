//
//  HomeView.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/21/25.
//

import SwiftUI

struct HomeView: View{
    @State private var navigateToSchedularView: Bool = false
    var body: some View{
        NavigationStack{
            ZStack{
                Color.yellow
                    .opacity(0.7)
                    .ignoresSafeArea()
                VStack{
                    Text("Hey there! Welcome to Workout Schedular")
                        .foregroundStyle(.red)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .shadow(radius: 5)
                    
                    Button(action: {
                        navigateToSchedularView = true
                    }){
                        Text("Lets get you a perfect plan >>")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.blue)
                            .background(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 40)
                    
                    NavigationLink(destination: NewPlanSchedularView(), isActive: $navigateToSchedularView){
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview{
    HomeView()
}
