import Foundation

enum Constants {
    // MARK: - Line Properties
    enum Line {
        static let minDiameter: Double = 0.08
        static let maxDiameter: Double = 0.60
        static let diameterStep: Double = 0.02
        
        static let minStrengthLb: Double = 2
        static let maxStrengthLb: Double = 100
        
        static let lbToKg: Double = 0.453592
    }
    
    // MARK: - Fish Properties
    enum Fish {
        static let minWeight: Double = 0.5
        static let maxWeight: Double = 100
    }
    
    // MARK: - Simulation
    enum Simulation {
        static let safeLoadThreshold: Double = 0.70
        static let warningLoadThreshold: Double = 0.90
        static let criticalLoadThreshold: Double = 1.0
        
        // Knot strength reduction
        static let clinchKnotReduction: Double = 0.05
        static let palomarKnotReduction: Double = 0.08
        static let poorKnotReduction: Double = 0.15
        
        // Wear factors
        static let newLineWear: Double = 0.0
        static let oneMonthWear: Double = 0.10
        static let threeMonthWear: Double = 0.25
        static let sixMonthWear: Double = 0.40
        
        // Fight dynamics
        static let calmFish: Double = 0.0
        static let activeFish: Double = 0.20
        static let aggressiveFish: Double = 0.50
        
        // Temperature
        static let coldWaterPenalty: Double = 0.05
    }
    
    // MARK: - UI
    enum UI {
        static let cornerRadius: CGFloat = 16
        static let smallCornerRadius: CGFloat = 8
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
        
        static let animationDuration: Double = 0.3
        static let longAnimationDuration: Double = 0.6
        static let simulationDuration: Double = 2.5
    }
    
    // MARK: - Storage Keys
    enum StorageKeys {
        static let testHistory = "testHistory"
        static let achievements = "achievements"
        static let savedCombinations = "savedCombinations"
        static let statistics = "statistics"
        static let unitPreference = "unitPreference"
        static let soundEnabled = "soundEnabled"
    }
}
