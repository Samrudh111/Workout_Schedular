//
//  HomeView.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/21/25.
//

import SwiftUI
import SwiftKeychainWrapper

struct HomeView: View{
    @EnvironmentObject var appState: AppState
    @State private var navigateToSchedularView: Bool = false
    @State private var savedPlan: [WorkoutDay] = []
    var body: some View{
        NavigationStack{
            ZStack{
                Color.green
                    .ignoresSafeArea()
                GeometryReader { geometry in
                        Image(systemName: "dumbbell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 1.5) // Large size
                            .foregroundColor(.gray.opacity(0.2))
                            .rotationEffect(.degrees(-35))
                            .position(x: geometry.size.width / 2, y: 350)
                }
                VStack{
                    Spacer()
                    Text("Welcome to Workout Schedular !")
                        .foregroundStyle(Color.yellow)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .shadow(radius: 6)
                    
                    if !savedPlan.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Weekly Workout Plan:")
                                .font(.title2)
                                .bold()
                                .padding(.bottom, 10)

                            ForEach(savedPlan) { day in
                                HStack {
                                    Text(day.day)
                                        .fontWeight(.semibold)
                                        .frame(width: 100, alignment: .leading)

                                    Text(day.workout)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding()
                                .background(isToday(day.day) ? Color.blue.opacity(0.3) : Color.white.opacity(0.6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(isToday(day.day) ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal)

                    }
                    
                    Button(action: {
                        navigateToSchedularView = true
                    }){
                        Text(savedPlan.isEmpty ? "Lets get you a perfect plan >>" : "Change my plan >")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.blue)
                            .background(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 40)
                    
                    Spacer()
                    Button("Logout"){
                        appState.isLoggedIn = false
                        appState.userPassword = ""
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundStyle(Color.white)
                    NavigationLink(destination: NewPlanSchedularView(), isActive: $navigateToSchedularView){
                        EmptyView()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchSavedPlanFromServer { fetched in
                self.savedPlan = fetched
            }
        }

        .onChange(of: navigateToSchedularView) { isNavigating in
            if !isNavigating{
                fetchSavedPlanFromServer { fetched in
                    self.savedPlan = fetched
                }
            }
        }
    }
    
    func fetchSavedPlanFromServer(completion: @escaping ([WorkoutDay]) -> Void) {
        guard let url = URL(string: "https://workout-schedular.onrender.com/user/plan") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = KeychainWrapper.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode([WorkoutDay].self, from: data)
                    DispatchQueue.main.async {
                        completion(decoded)
                    }
                } catch {
                    print("❌ Decoding error: \(error.localizedDescription)")
                }
            } else {
                print("❌ No data or network error:", error?.localizedDescription ?? "unknown error")
            }
        }.resume()
    }
    
    func isToday(_ dayName: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let today = formatter.string(from: Date())
        return dayName.caseInsensitiveCompare(today) == .orderedSame
    }
}

#Preview{
    HomeView()
}
