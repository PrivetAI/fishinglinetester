import Foundation

// MARK: - Line Type
enum LineType: String, CaseIterable, Codable, Identifiable {
    case monofilament
    case braided
    case fluorocarbon
    case hybrid
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .monofilament: return "Monofilament"
        case .braided: return "Braided"
        case .fluorocarbon: return "Fluorocarbon"
        case .hybrid: return "Hybrid"
        }
    }
    
    var shortName: String {
        switch self {
        case .monofilament: return "Mono"
        case .braided: return "Braid"
        case .fluorocarbon: return "Fluoro"
        case .hybrid: return "Hybrid"
        }
    }
    
    var description: String {
        switch self {
        case .monofilament:
            return "Single strand nylon line. Good stretch absorbs fish strikes. Affordable and versatile."
        case .braided:
            return "Woven fibres for maximum strength. Zero stretch for sensitivity. Thinner diameter."
        case .fluorocarbon:
            return "Nearly invisible underwater. Excellent abrasion resistance. Sinks naturally."
        case .hybrid:
            return "Combines best of mono and fluoro. Balanced properties for various conditions."
        }
    }
    
    var stretch: Stretch {
        switch self {
        case .monofilament: return .high
        case .braided: return .none
        case .fluorocarbon: return .low
        case .hybrid: return .medium
        }
    }
    
    var visibility: Visibility {
        switch self {
        case .monofilament: return .medium
        case .braided: return .high
        case .fluorocarbon: return .veryLow
        case .hybrid: return .low
        }
    }
    
    var durability: Durability {
        switch self {
        case .monofilament: return .medium
        case .braided: return .high
        case .fluorocarbon: return .high
        case .hybrid: return .medium
        }
    }
    
    var priceTier: PriceTier {
        switch self {
        case .monofilament: return .budget
        case .braided: return .premium
        case .fluorocarbon: return .premium
        case .hybrid: return .midRange
        }
    }
    
    var strengthMultiplier: Double {
        switch self {
        case .monofilament: return 1.0
        case .braided: return 2.0
        case .fluorocarbon: return 1.2
        case .hybrid: return 1.4
        }
    }
    
    var iconName: String {
        switch self {
        case .monofilament: return "line_mono"
        case .braided: return "line_braid"
        case .fluorocarbon: return "line_fluoro"
        case .hybrid: return "line_hybrid"
        }
    }
    
    var pros: [String] {
        switch self {
        case .monofilament:
            return ["Affordable", "Good stretch", "Universal", "Clear in water"]
        case .braided:
            return ["Very strong for diameter", "No stretch (sensitive)", "Long-lasting"]
        case .fluorocarbon:
            return ["Nearly invisible", "Abrasion resistant", "Sinks naturally"]
        case .hybrid:
            return ["Balanced properties", "Good value", "Versatile"]
        }
    }
    
    var cons: [String] {
        switch self {
        case .monofilament:
            return ["Lower strength per diameter", "UV degradation", "Memory (coiling)"]
        case .braided:
            return ["Expensive", "Visible in water", "Can cut on rocks"]
        case .fluorocarbon:
            return ["Expensive", "Stiff", "Memory issues"]
        case .hybrid:
            return ["Jack of all trades", "Not best at anything"]
        }
    }
    
    var bestFor: String {
        switch self {
        case .monofilament: return "Beginners, calm fish, general fishing"
        case .braided: return "Trophy fish, jigging, heavy cover"
        case .fluorocarbon: return "Leaders, clear water, wary fish"
        case .hybrid: return "All-round fishing, mixed conditions"
        }
    }
}

// MARK: - Line Properties Enums
enum Stretch: String, Codable {
    case none = "None"
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum Visibility: String, Codable {
    case veryLow = "Very Low"
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum Durability: String, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum PriceTier: String, Codable {
    case budget = "Budget"
    case midRange = "Mid-Range"
    case premium = "Premium"
}
