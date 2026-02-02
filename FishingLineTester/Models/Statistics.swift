import Foundation

// MARK: - Test Statistics
struct TestStatistics: Codable {
    var totalTests: Int = 0
    var successfulTests: Int = 0
    var failedTests: Int = 0
    var largestCatchWeightLb: Double = 0
    var largestCatchFishName: String = ""
    var closestCallPercentage: Double = 0
    var highestSafetyMargin: Double = 0
    var mostUsedLineTypeName: String? = nil
    var lineTypeUsageCounts: [String: Int] = [:]
    
    var successRate: Double {
        guard totalTests > 0 else { return 0 }
        return Double(successfulTests) / Double(totalTests)
    }
    
    var formattedSuccessRate: String {
        return String(format: "%.0f%%", successRate * 100)
    }
    
    var mostUsedLineType: LineType? {
        guard let name = mostUsedLineTypeName else { return nil }
        return LineType.allCases.first { $0.rawValue == name }
    }
    
    mutating func update(with result: SimulationResult) {
        totalTests += 1
        
        if result.success {
            successfulTests += 1
            
            // Track largest catch
            if result.fishWeight > largestCatchWeightLb {
                largestCatchWeightLb = result.fishWeight
                largestCatchFishName = result.fishName
            }
            
            // Track closest call (highest load that still succeeded)
            if result.loadPercentage > closestCallPercentage && result.loadPercentage < 1.0 {
                closestCallPercentage = result.loadPercentage
            }
            
            // Track highest safety margin
            if result.safetyMargin > highestSafetyMargin {
                highestSafetyMargin = result.safetyMargin
            }
        } else {
            failedTests += 1
        }
        
        // Track line type usage
        let typeName = result.line.type.rawValue
        lineTypeUsageCounts[typeName, default: 0] += 1
        
        // Update most used
        if let mostUsed = lineTypeUsageCounts.max(by: { $0.value < $1.value }) {
            mostUsedLineTypeName = mostUsed.key
        }
    }
}

// MARK: - Saved Combination
struct SavedCombination: Identifiable, Codable {
    let id: UUID
    var name: String
    var line: FishingLine
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(), name: String, line: FishingLine, notes: String = "") {
        self.id = id
        self.name = name
        self.line = line
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: updatedAt)
    }
}
