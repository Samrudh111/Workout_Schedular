//
//  LoginView.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/21/25.
//

import SwiftUI

struct LoginView: View{
    @State private var email = ""
    @State private var password = ""
    @State private var loginText = "Login"
    var body: some View{
        ZStack{
            BackgroundView()
            VStack{
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.black)
                    .padding(.bottom, 40)
                
                VStack(spacing: 20){
                    TextField("email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    SecureField("password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Button(action: {
                        loginText = "Logged in!"
                    }) {
                        Text(loginText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical)
                }
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .padding(.horizontal, 40)
                .shadow(radius: 5)
            }
        }
    }
}

struct BackgroundView: View {
    let equipmentIcons = ["dumbbell", "bicycle", "flame", "figure.walk", "figure.strengthtraining.traditional", "figure.strengthtraining.functional", "figure.run", "figure.cooldown", "bolt.fill"] //SF ICONS
    var body: some View {
        GeometryReader{geometry in
            let column = Int(geometry.size.width/70)
            let row = Int(geometry.size.height/70)
            Color.white
                .ignoresSafeArea()
            VStack(spacing: 20){
                ForEach(0..<row, id: \.self){ _ in
                    HStack(spacing: 20){
                        ForEach(0..<column, id: \.self){ _ in
                            Image(systemName: equipmentIcons.randomElement()!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                .foregroundStyle(.gray)
                                .opacity(0.25)
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}



#Preview {
    LoginView()
}
