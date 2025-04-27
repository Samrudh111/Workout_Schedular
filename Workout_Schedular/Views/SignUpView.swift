//
//  LoginView.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/21/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var showSuccess = false
    @State private var errorMessage: String?
    @State private var isPasswordVisible = false

    var body: some View {
        NavigationStack {
            if appState.isLoggedIn{
                HomeView()
            } else{
                ZStack {
                    BackgroundView()
                    VStack(spacing: 20) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

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

                        Button("Create Account") {
                            if isValidInput() {
                                signUpUser()
                            } else {
                                errorMessage = "Use a valid @example.com email and password of at least 5 characters"
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)

                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                }
            }
        }
    }

    func isValidInput() -> Bool {
        return email.contains("@") &&
               email.lowercased().hasSuffix(".com") &&
               password.count >= 5
    }
    
    func signUpUser() {
        guard let url = URL(string: "https://workout-schedular.onrender.com/signup") else { return }

        let body: [String: String] = [
            "email": email,
            "password": password
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid server response."
                }
                return
            }

            DispatchQueue.main.async {
                if httpResponse.statusCode == 201 {
                    appState.isLoggedIn = true
                    appState.userEmail = email
                    appState.userPassword = password
                } else {
                    errorMessage = "Account already exists or server error."
                }
            }
        }.resume()
    }
}


#Preview {
    SignUpView()
}
