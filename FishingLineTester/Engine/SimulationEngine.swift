import Foundation

// MARK: - Simulation Engine
final class SimulationEngine {
    
    /// Run a fishing simulation
    /// - Parameters:
    ///   - line: The fishing line being used
    ///   - fish: The fish being caught
    ///   - fishWeight: Specific weight of the fish (in lb)
    ///   - factors: Additional simulation factors
    /// - Returns: Simulation result with success/failure and load percentage
    static func simulate(
        line: FishingLine,
        fish: Fish,
        fishWeight: Double,
        factors: SimulationFactors = .defaults
    ) -> SimulationResult {
        // Calculate effective line strength
        let baseStrength = line.strengthLb
        let effectiveStrength = baseStrength * factors.effectiveStrengthMultiplier
        
        // Calculate effective fish load
        let effectiveLoad = fishWeight * factors.effectiveLoadMultiplier
        
        // Calculate load percentage
        let loadPercentage = effectiveLoad / effectiveStrength
        
        // Determine success
        let success = loadPercentage <= 1.0
        
        return SimulationResult(
            line: line,
            fishName: fish.name,
            fishWeight: fishWeight,
            loadPercentage: loadPercentage,
            success: success,
            factors: factors
        )
    }
    
    /// Quick simulation with random fish weight
    static func simulateRandom(
        line: FishingLine,
        fish: Fish,
        factors: SimulationFactors = .defaults
    ) -> SimulationResult {
        let weight = fish.randomWeight()
        return simulate(line: line, fish: fish, fishWeight: weight, factors: factors)
    }
    
    /// Calculate recommended line for a fish
    static func recommendedLine(for fish: Fish, safetyMargin: Double = 0.5) -> Double {
        let maxWeight = fish.maxWeightLb
        let fightMultiplier = fish.fightIntensity.loadMultiplier
        let effectiveWeight = maxWeight * fightMultiplier
        return effectiveWeight * (1 + safetyMargin)
    }
    
    /// Calculate if a line is suitable for a fish
    static func isSuitable(line: FishingLine, for fish: Fish, factors: SimulationFactors = .defaults) -> Bool {
        let effectiveStrength = line.strengthLb * factors.effectiveStrengthMultiplier
        let maxLoad = fish.maxWeightLb * factors.effectiveLoadMultiplier
        return effectiveStrength >= maxLoad
    }
    
    /// Get load zone for a percentage
    static func loadZone(for percentage: Double) -> LoadZone {
        switch percentage {
        case ..<Constants.Simulation.safeLoadThreshold:
            return .safe
        case ..<Constants.Simulation.warningLoadThreshold:
            return .moderate
        case ..<Constants.Simulation.criticalLoadThreshold:
            return .warning
        case ..<1.0:
            return .critical
        default:
            return .broken
        }
    }
}

// MARK: - Load Zone
enum LoadZone: String {
    case safe
    case moderate
    case warning
    case critical
    case broken
    
    var name: String {
        switch self {
        case .safe: return "Safe"
        case .moderate: return "Moderate"
        case .warning: return "Warning"
        case .critical: return "Critical"
        case .broken: return "Broken"
        }
    }
    
    var description: String {
        switch self {
        case .safe: return "Line is handling the load well"
        case .moderate: return "Load is significant but manageable"
        case .warning: return "Line is under heavy stress"
        case .critical: return "Line is at breaking point!"
        case .broken: return "Line has snapped!"
        }
    }
}
