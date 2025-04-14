//
//  UserManager.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 4/12/25.
//

import SwiftUI

class UserManager {
    static let shared = UserManager()
    private let emailKey = "Ss"
    private let passwordKey = "Pp"

    func saveUser(email: String, password: String) {
        UserDefaults.standard.set(email, forKey: emailKey)
        UserDefaults.standard.set(password, forKey: passwordKey)
    }

    func isUserLoggedIn() -> Bool {
        return getUserEmail() != nil && getUserPassword() != nil
    }

    func getUserEmail() -> String? {
        UserDefaults.standard.string(forKey: emailKey)
    }

    func getUserPassword() -> String? {
        UserDefaults.standard.string(forKey: passwordKey)
    }

    func validateUser(email: String, password: String) -> Bool {
        //return email == getUserEmail() && password == getUserPassword()
        return email == "Ss" && password == "Pp"
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: emailKey)
        UserDefaults.standard.removeObject(forKey: passwordKey)
    }
}
