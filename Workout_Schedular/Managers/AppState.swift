//
//  AppState.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 4/12/25.
//

import SwiftUI

class AppState: ObservableObject{
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("userEmail") var userEmail = ""
    @AppStorage("userPassword") var userPassword = ""
}
