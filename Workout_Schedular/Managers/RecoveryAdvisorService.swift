//
//  RecoveryAdvisorService.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 2/10/25.
//

import Foundation
import CoreML

enum RecoveryRecommendation: String {
    case trainHard = "TrainHard"
    case trainNormal = "TrainNormal"
    case takeItEasy = "TakeItEasy"
    case rest = "Rest"
}

final class RecoveryAdvisorService {
    static let shared = RecoveryAdvisorService()
    private let model: RecoveryAdvisor
    
    private init() {
        let config = MLModelConfiguration()
        self.model = try! RecoveryAdvisor(configuration: config)
    }
    
    func recommendation(
        completedYesterday: Bool,
        yesterdayDifficulty: Double,
        sleepHours: Double,
        fatigueLevel: Double,
        sorenessLevel: Double
    ) -> RecoveryRecommendation {
        
        let input = RecoveryAdvisorInput(
            completedYesterday: completedYesterday ? 1 : 0,
            yesterdayDifficulty: Int64(yesterdayDifficulty),
            sleepHours: sleepHours,
            fatigueLevel: Int64(fatigueLevel),
            sorenessLevel: Int64(sorenessLevel)
        )
        
        guard let output = try? model.prediction(input: input) else {
            return .trainNormal    // safe default
        }
        
        return RecoveryRecommendation(rawValue: output.recommendation) ?? .trainNormal
    }
}
