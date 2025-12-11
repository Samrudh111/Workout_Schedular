//
//  ActivitySummaryView.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/10/25.
//

import SwiftUI

struct ActivitySummaryView: View {
    @State private var steps: Double = 0
    @State private var activeEnergy: Double = 0
    @State private var exerciseMinutes: Double = 0
    @State private var isAuthorized = false
    @Binding var showActivityMonitor: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Activity")
                .font(.headline)
            
            if isAuthorized {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Steps")
                            .font(.caption)
                        Text("\(Int(steps))")
                            .font(.title3)
                            .bold()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Active kcal")
                            .font(.caption)
                        Text("\(Int(activeEnergy))")
                            .font(.title3)
                            .bold()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Exercise")
                            .font(.caption)
                        Text("\(Int(exerciseMinutes)) min")
                            .font(.title3)
                            .bold()
                    }
                }
            } else {
                Text("Enable Health access to see today's steps and calories.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal)
        .onAppear {
            requestAndLoad()
        }
//        .toolbar {
//            ToolbarItem(placement: .destructiveAction) {
//                Button {
//                    
//                } label: {
//                    Text("Close")
//                }
//
//            }
//        }
    }
    
    private func requestAndLoad() {
        HealthKitManager.shared.requestAuthorization { success in
            self.isAuthorized = success
            guard success else { return }
            
            HealthKitManager.shared.fetchTodaySteps { self.steps = $0 }
            HealthKitManager.shared.fetchTodayActiveEnergy { self.activeEnergy = $0 }
            HealthKitManager.shared.fetchTodayExerciseMinutes { self.exerciseMinutes = $0 }
        }
    }
}
