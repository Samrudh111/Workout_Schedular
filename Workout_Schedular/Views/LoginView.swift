//
//  LoginView.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/21/25.
//

import SwiftUI
import SwiftKeychainWrapper

struct LoginView: View{
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var showLoginError = false
    @State private var loginErrorMessage = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if appState.isLoggedIn {
                    HomeView()
                } else {
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
                            ZStack{
                                if !isPasswordVisible{
                                    SecureField("password", text: $password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal)
                                } else {
                                    TextField("password", text: $password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal)
                                }
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 5.5)
                                            .foregroundStyle(Color.gray)
                                    }
                                    .background(Color.white)
                                    .padding(.horizontal, 18)
                                }
                            }
                            
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
                    }
                }
            }
            .onAppear{
                if appState.userEmail != ""{
                    email = appState.userEmail
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

        if let token = KeychainWrapper.standard.string(forKey: "authToken") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    appState.isLoggedIn = true
                    appState.userEmail = email
                    appState.userPassword = password
                } else {
                    loginErrorMessage = "Invalid email or password. Try again."
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
        .environmentObject(AppState())
}
