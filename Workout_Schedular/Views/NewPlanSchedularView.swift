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
    @State private var gender: String = ""
    @State private var selectedLevel = "Level 1 (Beginner)"
    let levels = ["Level 1 (Beginner)", "Level 2 (Intermediate)", "Level 3 (Pro)"]
    @State private var bmiValue: Double?
    @State private var bmiCategory: String = ""
    @State private var selectedGoal = "Lean"
    let goals = ["Lean", "Muscular", "Bulky Solid"]
    let genders = ["Male", "Female"]
    let heightOptions = (100...250).map(String.init)
    let weightOptions = (30...200).map(String.init)
    let ageOptions = (10...100).map(String.init)
    @State private var workoutPlan: [WorkoutDay] = []
    @State private var showValidationError = false
    @State private var dailyCalories: Double?
    @State private var dailyProtein: Double?

    var heightPicker: some View {
        VStack(alignment: .leading) {
            Text("Height:")
            Menu {
                ForEach(heightOptions, id: \.self) { value in
                    Button(value) { height = value }
                }
            } label: {
                HStack {
                    Text(height.isEmpty ? "Choose..." : height)
                    Image(systemName: "chevron.down")
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }

    var weightPicker: some View {
        VStack(alignment: .leading) {
            Text("Weight:")
            Menu {
                ForEach(weightOptions, id: \.self) { value in
                    Button(value) { weight = value }
                }
            } label: {
                HStack {
                    Text(weight.isEmpty ? "Choose..." : weight)
                    Image(systemName: "chevron.down")
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }

    var agePicker: some View {
        VStack(alignment: .leading) {
            Text("Age:")
            Menu {
                ForEach(ageOptions, id: \.self) { value in
                    Button(value) { age = value }
                }
            } label: {
                HStack {
                    Text(age.isEmpty ? "Choose..." : age)
                    Image(systemName: "chevron.down")
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }

    var genderPicker: some View {
        VStack(alignment: .leading) {
            Text("Gender:")
            Menu {
                ForEach(genders, id: \.self) { value in
                    Button(value) { gender = value }
                }
            } label: {
                HStack {
                    Text(gender.isEmpty ? "Choose..." : gender)
                    Image(systemName: "chevron.down")
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }

    var levelPicker: some View {
        VStack(alignment: .leading) {
            Text("Choose your level:")
            Picker("Level", selection: $selectedLevel) {
                ForEach(levels, id: \.self) { level in
                    Text(level)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.horizontal)
    }

    var body: some View {
        ScrollView {
            ZStack{
                GeometryReader { geometry in
                        Image(systemName: "dumbbell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 1.5) // Large size
                            .foregroundColor(.gray.opacity(0.1))
                            .rotationEffect(.degrees(-35))
                            .position(x: geometry.size.width / 2, y: 350)
                }
                
                VStack(spacing: 20) {
                    Spacer()
                    Text("BMI Calculator")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)

                    Group {
                        HStack(spacing: 16) {
                            heightPicker.frame(maxWidth: .infinity)
                            weightPicker.frame(maxWidth: .infinity)
                        }

                        HStack(spacing: 16) {
                            agePicker.frame(maxWidth: .infinity)
                            genderPicker.frame(maxWidth: .infinity)
                        }

                        HStack {
                            Spacer()
                            Button(action: resetFields) {
                                Text("Reset")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onChange(of: height) { _ in calculateBMI() }
                    .onChange(of: weight) { _ in calculateBMI() }
                    .onChange(of: age) { _ in calculateBMI() }
                    .onChange(of: gender) { _ in calculateBMI() }
                    .onChange(of: selectedGoal) { _ in calculateBMI() }
                    .onChange(of: selectedLevel) { _ in calculateBMI() }
                    
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

                    VStack(alignment: .leading) {
                        Text("Choose your goal:")
                        Picker("Select your goal", selection: $selectedGoal) {
                            ForEach(goals, id: \.self) { goal in
                                Text(goal)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.horizontal)

                    levelPicker

                    if showValidationError {
                        Text("Please fill in all fields.")
                            .foregroundColor(.red)
                    }

                    Button("Submit") {
                        if validateInputs() {
                            submitForWorkoutPlan()
                        } else {
                            showValidationError = true
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    if !workoutPlan.isEmpty {
                        ForEach(workoutPlan) { day in
                            VStack(alignment: .leading) {
                                Text(day.day)
                                    .font(.headline)
                                Text(day.workout)
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    if let calories = dailyCalories, let protein = dailyProtein {
                        Text("Estimated Daily Intake: \(Int(calories)) kcal • \(Int(protein))g protein")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                }

            }
            .padding()
        }
        .ignoresSafeArea()
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
        
        guard let ageInt = Double(age) else { return }
        var bmr: Double
        let weightComponent = 10 * weightKg
        let heightComponent = 6.25 * heightCm
        let ageComponent = 5 * ageInt

        if gender.lowercased() == "male" {
            bmr = weightComponent + heightComponent - ageComponent + 5
        } else {
            bmr = weightComponent + heightComponent - ageComponent - 161
        }

        // Activity multiplier
        let activityMultiplier: Double = {
            switch selectedLevel {
            case "Level 1 (Beginner)": return 1.4
            case "Level 2 (Intermediate)": return 1.6
            case "Level 3 (Pro)": return 1.8
            default: return 1.5
            }
        }()

        // Calorie adjustment
        let goalAdjustment: Double = {
            switch selectedGoal.lowercased() {
            case "lean": return -250
            case "bulky solid": return 250
            default: return 0
            }
        }()
        let maintenance = bmr * activityMultiplier
        dailyCalories = maintenance + goalAdjustment
        dailyProtein = weightKg * 2.0
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
        gender = ""
        bmiValue = nil
        bmiCategory = ""
        showValidationError = false
    }

    func validateInputs() -> Bool {
        return !height.isEmpty && !weight.isEmpty && !age.isEmpty && !gender.isEmpty
    }

    func submitForWorkoutPlan() {
        guard let bmiValue = bmiValue else { return }
        let url = URL(string: "https://workout-schedular.onrender.com/generate-plan")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "bmi": bmiValue,
            "goal": selectedGoal,
            "gender": gender,
            "level": selectedLevel
        ]
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
                    savePlanToServer(plan: decoded)
                    self.showValidationError = false
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func savePlanToServer(plan: [WorkoutDay]) {
        guard let url = URL(string: "https://workout-schedular.onrender.com/user/plan") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = KeychainWrapper.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let planData = plan.map { ["day": $0.day, "workout": $0.workout] }
        request.httpBody = try? JSONSerialization.data(withJSONObject: planData)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error saving plan:", error.localizedDescription)
                return
            }
            print("✅ Plan saved to backend")
        }.resume()
    }
}

struct WorkoutDay: Identifiable, Codable {
    let id = UUID()
    let day: String
    let workout: String
}

#Preview {
    NewPlanSchedularView()
}
