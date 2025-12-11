//
//  WorkoutStorageManager.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 5/23/25.
//

import SwiftUI

class WorkoutStorageManager {
    static let key = "SavedWorkoutPlan"

    static func savePlan(_ plan: [WorkoutDay]) {
        if let data = try? JSONEncoder().encode(plan) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func loadPlan() -> [WorkoutDay] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([WorkoutDay].self, from: data) else {
            return []
        }
        return decoded
    }

    static func clearPlan() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

