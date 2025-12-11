//
//  DailyCheckInView.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 2/10/25.
//

import SwiftUI

struct DailyCheckInView: View {
    @Binding var completedYesterday: Bool
    @Binding var sleepHours: Double
    @Binding var fatigueLevel: Double
    @Binding var sorenessLevel: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Completed yesterday's workout", isOn: $completedYesterday)
            
            VStack(alignment: .leading) {
                Text("Sleep hours: \(sleepHours, specifier: "%.1f")")
                Slider(value: $sleepHours, in: 0...12, step: 0.5)
            }
            
            VStack(alignment: .leading) {
                Text("Fatigue level: \(Int(fatigueLevel)) / 5")
                Slider(value: $fatigueLevel, in: 1...5, step: 1)
            }
            
            VStack(alignment: .leading) {
                Text("Soreness level: \(Int(sorenessLevel)) / 5")
                Slider(value: $sorenessLevel, in: 1...5, step: 1)
            }
        }
        .padding()
    }
}
