import Foundation

// MARK: - Fishing Line Model
struct FishingLine: Codable, Identifiable, Equatable {
    let id: UUID
    var type: LineType
    var diameter: Double // in mm
    var strengthLb: Double // in pounds
    
    var strengthKg: Double {
        strengthLb * Constants.Line.lbToKg
    }
    
    init(id: UUID = UUID(), type: LineType, diameter: Double) {
        self.id = id
        self.type = type
        self.diameter = diameter
        self.strengthLb = FishingLine.calculateStrength(type: type, diameter: diameter)
    }
    
    init(id: UUID = UUID(), type: LineType, diameter: Double, strengthLb: Double) {
        self.id = id
        self.type = type
        self.diameter = diameter
        self.strengthLb = strengthLb
    }
    
    // Calculate strength based on type and diameter
    static func calculateStrength(type: LineType, diameter: Double) -> Double {
        // Base formula: strength increases with diameter squared
        // Different line types have different strength multipliers
        let baseFactor: Double = 200 // Calibration factor
        let diameterSquared = diameter * diameter
        let baseStrength = diameterSquared * baseFactor
        let strength = baseStrength * type.strengthMultiplier
        
        // Clamp to realistic values
        return min(max(strength, 2), 100)
    }
    
    var formattedDiameter: String {
        String(format: "%.2f mm", diameter)
    }
    
    var formattedStrengthLb: String {
        String(format: "%.1f lb", strengthLb)
    }
    
    var formattedStrengthKg: String {
        String(format: "%.1f kg", strengthKg)
    }
    
    var displayName: String {
        "\(type.shortName) \(formattedDiameter)"
    }
}

// MARK: - Knot Type
enum KnotType: String, CaseIterable, Codable, Identifiable {
    case none
    case clinch
    case palomar
    case poor
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .none: return "No Knot"
        case .clinch: return "Clinch Knot"
        case .palomar: return "Palomar Knot"
        case .poor: return "Poor Knot"
        }
    }
    
    var strengthReduction: Double {
        switch self {
        case .none: return 0.0
        case .clinch: return Constants.Simulation.clinchKnotReduction
        case .palomar: return Constants.Simulation.palomarKnotReduction
        case .poor: return Constants.Simulation.poorKnotReduction
        }
    }
    
    var description: String {
        switch self {
        case .none: return "Direct connection, full strength"
        case .clinch: return "Simple and popular, minimal strength loss (-5%)"
        case .palomar: return "Very strong, slight reduction (-8%)"
        case .poor: return "Badly tied, significant loss (-15%)"
        }
    }
}

// MARK: - Line Wear
enum LineWear: String, CaseIterable, Codable, Identifiable {
    case new
    case oneMonth
    case threeMonths
    case sixMonths
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .new: return "New Line"
        case .oneMonth: return "1 Month Used"
        case .threeMonths: return "3 Months Used"
        case .sixMonths: return "6 Months Used"
        }
    }
    
    var strengthReduction: Double {
        switch self {
        case .new: return Constants.Simulation.newLineWear
        case .oneMonth: return Constants.Simulation.oneMonthWear
        case .threeMonths: return Constants.Simulation.threeMonthWear
        case .sixMonths: return Constants.Simulation.sixMonthWear
        }
    }
    
    var percentage: String {
        switch self {
        case .new: return "100%"
        case .oneMonth: return "90%"
        case .threeMonths: return "75%"
        case .sixMonths: return "60%"
        }
    }
}


