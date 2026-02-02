import Foundation

// MARK: - Fish Category
enum FishCategory: String, CaseIterable, Codable {
    case small = "Small Fish"
    case medium = "Medium Fish"
    case large = "Large Fish"
    case trophy = "Trophy Fish"
    
    var description: String {
        switch self {
        case .small: return "Safe for any line"
        case .medium: return "Requires proper line selection"
        case .large: return "Tests line strength"
        case .trophy: return "Extreme challenge"
        }
    }
}

// MARK: - Fight Intensity
enum FightIntensity: String, CaseIterable, Codable {
    case calm
    case active
    case aggressive
    
    var name: String {
        switch self {
        case .calm: return "Calm"
        case .active: return "Active"
        case .aggressive: return "Aggressive"
        }
    }
    
    var loadMultiplier: Double {
        switch self {
        case .calm: return 1.0 + Constants.Simulation.calmFish
        case .active: return 1.0 + Constants.Simulation.activeFish
        case .aggressive: return 1.0 + Constants.Simulation.aggressiveFish
        }
    }
}

// MARK: - Fish Model
struct Fish: Identifiable, Codable {
    let id: UUID
    let name: String
    let minWeightLb: Double
    let maxWeightLb: Double
    let category: FishCategory
    let fightIntensity: FightIntensity
    let iconName: String
    let description: String
    
    var minWeightKg: Double { minWeightLb * Constants.Line.lbToKg }
    var maxWeightKg: Double { maxWeightLb * Constants.Line.lbToKg }
    
    var weightRangeLb: String {
        String(format: "%.1f - %.1f lb", minWeightLb, maxWeightLb)
    }
    
    var weightRangeKg: String {
        String(format: "%.1f - %.1f kg", minWeightKg, maxWeightKg)
    }
    
    var recommendedLineLb: Double {
        maxWeightLb * 1.5 // 50% safety margin
    }
    
    func randomWeight() -> Double {
        Double.random(in: minWeightLb...maxWeightLb)
    }
    
    init(id: UUID = UUID(), name: String, minWeightLb: Double, maxWeightLb: Double, 
         category: FishCategory, fightIntensity: FightIntensity, iconName: String, description: String) {
        self.id = id
        self.name = name
        self.minWeightLb = minWeightLb
        self.maxWeightLb = maxWeightLb
        self.category = category
        self.fightIntensity = fightIntensity
        self.iconName = iconName
        self.description = description
    }
}

// MARK: - Fish Database
struct FishDatabase {
    static let allFish: [Fish] = [
        // Small Fish
        Fish(name: "Perch", minWeightLb: 0.5, maxWeightLb: 1.0, 
             category: .small, fightIntensity: .calm,
             iconName: "fish_perch", description: "Common freshwater fish, easy to catch"),
        Fish(name: "Roach", minWeightLb: 0.3, maxWeightLb: 0.8, 
             category: .small, fightIntensity: .calm,
             iconName: "fish_roach", description: "Silver-scaled schooling fish"),
        Fish(name: "Crucian Carp", minWeightLb: 0.5, maxWeightLb: 1.5, 
             category: .small, fightIntensity: .calm,
             iconName: "fish_crucian", description: "Hardy pond fish, gentle fighter"),
        Fish(name: "Bluegill", minWeightLb: 0.3, maxWeightLb: 1.0, 
             category: .small, fightIntensity: .active,
             iconName: "fish_bluegill", description: "Colourful panfish, fun to catch"),
        
        // Medium Fish
        Fish(name: "Trout", minWeightLb: 2.0, maxWeightLb: 4.0, 
             category: .medium, fightIntensity: .active,
             iconName: "fish_trout", description: "Spotted gamefish, strong fighter"),
        Fish(name: "Zander", minWeightLb: 3.0, maxWeightLb: 6.0, 
             category: .medium, fightIntensity: .active,
             iconName: "fish_zander", description: "Predatory fish, prized catch"),
        Fish(name: "Small Pike", minWeightLb: 4.0, maxWeightLb: 8.0, 
             category: .medium, fightIntensity: .aggressive,
             iconName: "fish_pike_small", description: "Young pike, aggressive strikes"),
        Fish(name: "Bass", minWeightLb: 2.0, maxWeightLb: 5.0, 
             category: .medium, fightIntensity: .aggressive,
             iconName: "fish_bass", description: "Popular sportfish, explosive fights"),
        
        // Large Fish
        Fish(name: "Pike", minWeightLb: 10.0, maxWeightLb: 20.0, 
             category: .large, fightIntensity: .aggressive,
             iconName: "fish_pike", description: "Apex freshwater predator"),
        Fish(name: "Catfish", minWeightLb: 15.0, maxWeightLb: 30.0, 
             category: .large, fightIntensity: .active,
             iconName: "fish_catfish", description: "Bottom dweller, powerful runs"),
        Fish(name: "Carp", minWeightLb: 8.0, maxWeightLb: 18.0, 
             category: .large, fightIntensity: .active,
             iconName: "fish_carp", description: "Strong fish, long battles"),
        Fish(name: "Salmon", minWeightLb: 8.0, maxWeightLb: 15.0, 
             category: .large, fightIntensity: .aggressive,
             iconName: "fish_salmon", description: "Powerful leaper, prized catch"),
        
        // Trophy Fish
        Fish(name: "Northern Pike", minWeightLb: 25.0, maxWeightLb: 40.0, 
             category: .trophy, fightIntensity: .aggressive,
             iconName: "fish_northern_pike", description: "Monster pike, ultimate challenge"),
        Fish(name: "Large Catfish", minWeightLb: 40.0, maxWeightLb: 80.0, 
             category: .trophy, fightIntensity: .active,
             iconName: "fish_large_catfish", description: "River monster, incredible strength"),
        Fish(name: "Sturgeon", minWeightLb: 60.0, maxWeightLb: 100.0, 
             category: .trophy, fightIntensity: .active,
             iconName: "fish_sturgeon", description: "Ancient giant, once-in-a-lifetime catch"),
        Fish(name: "Muskie", minWeightLb: 20.0, maxWeightLb: 50.0, 
             category: .trophy, fightIntensity: .aggressive,
             iconName: "fish_muskie", description: "Fish of 10,000 casts, legendary predator"),
    ]
    
    static func fish(forCategory category: FishCategory) -> [Fish] {
        allFish.filter { $0.category == category }
    }
    
    static func randomFish() -> Fish {
        allFish.randomElement()!
    }
    
    static func randomFish(inCategory category: FishCategory) -> Fish {
        fish(forCategory: category).randomElement()!
    }
}
