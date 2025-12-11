//
//  HealthKitManager.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 3/10/25.
//

import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    private init() {}
    
    // MARK: - Authorization
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        
        // Types we want to read
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        let readTypes: Set<HKObjectType> = [stepType, activeEnergyType, exerciseType]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func todayPredicate() -> NSPredicate {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        return HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
    }
    
    func fetchTodaySteps(completion: @escaping (Double) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(0)
            return
        }
        
        let predicate = todayPredicate()
        let query = HKStatisticsQuery(quantityType: stepType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, stats, _ in
            let value = stats?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async {
                completion(value)
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayActiveEnergy(completion: @escaping (Double) -> Void) {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(0)
            return
        }
        
        let predicate = todayPredicate()
        let query = HKStatisticsQuery(quantityType: energyType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, stats, _ in
            let value = stats?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            DispatchQueue.main.async {
                completion(value)
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayExerciseMinutes(completion: @escaping (Double) -> Void) {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion(0)
            return
        }
        
        let predicate = todayPredicate()
        let query = HKStatisticsQuery(quantityType: exerciseType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, stats, _ in
            let value = stats?.sumQuantity()?.doubleValue(for: .minute()) ?? 0
            DispatchQueue.main.async {
                completion(value)
            }
        }
        healthStore.execute(query)
    }
}
