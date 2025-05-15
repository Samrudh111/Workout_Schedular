//
//  NewPlanSchedularView.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/29/25.
//

import SwiftUI
import SwiftKeychainWrapper

struct NewPlanSchedularView: View {
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var age: String = ""
    @State private var bmiValue: Double?
    @State private var bmiCategory: String = ""
    @State private var selectedGoal = "Lean"
    let goals = ["Lean", "Bulky", "Lean Muscular"]
    @State private var workoutPlan: [WorkoutDay] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("BMI Calculator")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Group {
                TextField("Enter height in cm", text: $height)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Enter weight in kg", text: $weight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Enter age", text: $age)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                HStack{
                    Spacer()
                    Button(action: resetFields) {
                        Text("Reset")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
            .onChange(of: height) { _ in
                calculateBMI()
            }
            .onChange(of: weight) { _ in
                calculateBMI()
            }

            if let bmi = bmiValue {
                VStack(spacing: 8) {
                    Text("Your BMI is \(String(format: "%.1f", bmi))")
                        .font(.title2)

                    Text("Category: \(bmiCategory)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            Picker("Select your goal", selection: $selectedGoal) {
                ForEach(goals, id: \.self) { goal in
                    Text(goal)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Button("Submit") {
                submitForWorkoutPlan()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            if !workoutPlan.isEmpty {
                List(workoutPlan) { day in
                    VStack(alignment: .leading) {
                        Text(day.day)
                            .font(.headline)
                        Text(day.workout)
                            .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
            }
            Spacer()
        }
        .padding()
    }

    func calculateBMI() {
        guard let heightCm = Double(height), let weightKg = Double(weight), heightCm > 0 else {
            bmiValue = nil
            bmiCategory = ""
            return
        }

        let heightM = heightCm / 100.0
        let bmi = weightKg / (heightM * heightM)
        bmiValue = bmi
        bmiCategory = getBMICategory(for: bmi)
    }

    func getBMICategory(for bmi: Double) -> String {
        switch bmi {
        case ..<18.5:
            return "Underweight"
        case 18.5..<24.9:
            return "Normal weight"
        case 25.0..<29.9:
            return "Overweight"
        default:
            return "Obese"
        }
    }

    func resetFields() {
        height = ""
        weight = ""
        age = ""
        bmiValue = nil
        bmiCategory = ""
    }
    
    func submitForWorkoutPlan() {
        guard let bmiValue = bmiValue else { return }

        let url = URL(string: "https://workout-schedular.onrender.com/generate-plan")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["bmi": bmiValue, "goal": selectedGoal]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        if let token = KeychainWrapper.standard.string(forKey: "authToken") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data / error: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            do {
                let decoded = try JSONDecoder().decode([WorkoutDay].self, from: data)
                DispatchQueue.main.async {
                    self.workoutPlan = decoded
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct WorkoutDay: Identifiable, Decodable {
    let id = UUID()
    let day: String
    let workout: String
}


#Preview {
    NewPlanSchedularView()
}
