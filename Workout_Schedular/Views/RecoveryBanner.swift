//
//  RecoveryBanner.swift
//  Workout_Schedular
//
//  Created by Samrudh S on 2/10/25.
//

import SwiftUI

struct RecoveryBanner: View {
    let recommendation: RecoveryRecommendation
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(message)
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .background(backgroundColor.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
    
    private var iconName: String {
        switch recommendation {
        case .trainHard: return "bolt.fill"
        case .trainNormal: return "figure.strengthtraining.traditional"
        case .takeItEasy: return "tortoise.fill"
        case .rest: return "bed.double.fill"
        }
    }
    
    private var message: String {
        switch recommendation {
        case .trainHard:
            return "You’re well recovered. Push a bit harder today!"
        case .trainNormal:
            return "You’re in a good spot. Follow today’s plan as is."
        case .takeItEasy:
            return "You seem a bit fatigued. We suggest a lighter day."
        case .rest:
            return "High fatigue and soreness detected. Consider a rest day."
        }
    }
    
    private var backgroundColor: Color {
        switch recommendation {
        case .trainHard: return .green
        case .trainNormal: return .blue
        case .takeItEasy: return .orange
        case .rest: return .red
        }
    }
}
