import Foundation

// MARK: - Simulation Result
struct SimulationResult: Codable, Identifiable {
    let id: UUID
    let line: FishingLine
    let fishName: String
    let fishWeight: Double
    let loadPercentage: Double
    let success: Bool
    let factors: SimulationFactors
    let timestamp: Date
    
    var isCritical: Bool {
        loadPercentage >= 0.90 && loadPercentage < 1.0
    }
    
    var safetyMargin: Double {
        max(0, 1.0 - loadPercentage)
    }
    
    var overloadAmount: Double {
        max(0, loadPercentage - 1.0)
    }
    
    var formattedLoadPercentage: String {
        String(format: "%.0f%%", loadPercentage * 100)
    }
    
    var resultMessage: String {
        if success {
            if isCritical {
                return "Critical load! Fish caught, but line was at the limit!"
            } else {
                return "Fish caught! Safety margin: \(String(format: "%.0f%%", safetyMargin * 100))"
            }
        } else {
            return "Line broke! Overloaded by \(String(format: "%.0f%%", overloadAmount * 100))"
        }
    }
    
    init(id: UUID = UUID(), line: FishingLine, fishName: String, fishWeight: Double, 
         loadPercentage: Double, success: Bool, factors: SimulationFactors) {
        self.id = id
        self.line = line
        self.fishName = fishName
        self.fishWeight = fishWeight
        self.loadPercentage = loadPercentage
        self.success = success
        self.factors = factors
        self.timestamp = Date()
    }
}

// MARK: - Simulation Factors
struct SimulationFactors: Codable {
    let knot: KnotType
    let wear: LineWear
    let fightIntensity: FightIntensity
    let coldWater: Bool
    
    var effectiveStrengthMultiplier: Double {
        var multiplier = 1.0
        multiplier -= knot.strengthReduction
        multiplier -= wear.strengthReduction
        if coldWater {
            multiplier -= Constants.Simulation.coldWaterPenalty
        }
        return max(0.1, multiplier)
    }
    
    var effectiveLoadMultiplier: Double {
        fightIntensity.loadMultiplier
    }
    
    var factorsSummary: String {
        var parts: [String] = []
        if knot != .none {
            parts.append("\(knot.name): -\(Int(knot.strengthReduction * 100))%")
        }
        if wear != .new {
            parts.append("\(wear.name): -\(Int(wear.strengthReduction * 100))%")
        }
        if fightIntensity != .calm {
            parts.append("\(fightIntensity.name) fight: +\(Int((fightIntensity.loadMultiplier - 1) * 100))%")
        }
        if coldWater {
            parts.append("Cold water: -\(Int(Constants.Simulation.coldWaterPenalty * 100))%")
        }
        return parts.isEmpty ? "No modifiers" : parts.joined(separator: ", ")
    }
    
    static let defaults = SimulationFactors(knot: .none, wear: .new, fightIntensity: .calm, coldWater: false)
}


