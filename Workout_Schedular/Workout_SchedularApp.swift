//
//  Workout_SchedularApp.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/19/25.
//

import SwiftUI

@main
struct Workout_SchedularApp: App {
    @StateObject var appState = AppState()
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(appState)
        }
    }
}
