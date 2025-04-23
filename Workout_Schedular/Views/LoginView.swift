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
    @State private var showLoginError = false
    @State private var loginErrorMessage = ""
    @State private var navigateToHome = false

    var body: some View{
        NavigationStack{
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
                        
                        Button("Login"){
                            if isValidInput(){
                                loginUser()
                            } else {
                                loginErrorMessage = "Use a valid @example.com email and password of at least 5 characters"
                                showLoginError = true
                            }
                        }
                        .alert(isPresented: $showLoginError) {Alert(title: Text("Login Failed"), message: Text(loginErrorMessage), dismissButton: .default(Text("OK")))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 50)
                        
                        NavigationLink(destination: SignUpView()){
                            Text("New User? Create an account")
                                .font(.footnote)
                                .foregroundStyle(Color.blue)
                                .underline()
                        }
                        .padding()
                    }
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .shadow(radius: 5)
                    
                    NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                        EmptyView()
                    }.alert(isPresented: $showLoginError){
                        Alert(title: Text("Invalid Login"), message: Text("Invalid email or password, Try again"), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
        
    }
    
    func loginUser() {
        guard let url = URL(string: "https://workout-schedular.onrender.com/login") else { return }

        let body = ["email": email, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    navigateToHome = true
                } else {
                    loginErrorMessage = "Invalid email or password"
                    showLoginError = true
                }
            }
        }.resume()
    }
    
    func isValidInput() -> Bool {
        return email.contains("@") &&
               email.lowercased().hasSuffix(".com") &&
               password.count >= 5
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
