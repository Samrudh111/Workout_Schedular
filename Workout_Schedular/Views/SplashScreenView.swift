//
//  ContentView.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/19/25.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var appState: AppState
    @State var scaleValue: CGFloat = 0.8
    @State var showSplash = true
    @State var animate = false
    var body: some View {
        ZStack{
            if showSplash{
                GeometryReader { geometry in
                    ZStack{
                        Color.black
                            .ignoresSafeArea(.all)
                        Image("Arnold_Conquer")
                            .resizable()
                            .frame(width: geometry.size.width)
                            .scaleEffect(y: scaleValue, anchor: .center)
                            .clipped()
                            .ignoresSafeArea()
                            .onAppear{
                                withAnimation(.easeInOut(duration: 2.5)){
                                    scaleValue = geometry.size.height / geometry.size.width
                                }
                            }
                    }
                }
                .transition(.opacity)
            }
            else{
                if appState.isLoggedIn{
                    HomeView()
                        .transition(.opacity)
                } else{
                    LoginView()
                        .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut(duration: 0.8), value: showSplash)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                showSplash = false
            }
        }
    }
}

#Preview{
    SplashScreenView()
}
