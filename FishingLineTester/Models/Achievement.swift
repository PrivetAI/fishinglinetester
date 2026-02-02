import Foundation

// MARK: - Achievement
struct Achievement: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let iconName: String
    let requirement: Int
    var progress: Int
    var unlocked: Bool
    var unlockedAt: Date?
    
    var progressPercentage: Double {
        guard requirement > 0 else { return 0 }
        return min(1.0, Double(progress) / Double(requirement))
    }
    
    var formattedProgress: String {
        "\(progress)/\(requirement)"
    }
    
    init(id: String, name: String, description: String, iconName: String, requirement: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.iconName = iconName
        self.requirement = requirement
        self.progress = 0
        self.unlocked = false
        self.unlockedAt = nil
    }
    
    mutating func updateProgress(_ newProgress: Int) {
        progress = newProgress
        if progress >= requirement && !unlocked {
            unlocked = true
            unlockedAt = Date()
        }
    }
}

// MARK: - Achievement Definitions
struct AchievementDefinitions {
    static let all: [Achievement] = [
        Achievement(
            id: "beginner",
            name: "Beginner",
            description: "Complete 10 tests",
            iconName: "achievement_beginner",
            requirement: 10
        ),
        Achievement(
            id: "experienced",
            name: "Experienced Angler",
            description: "Complete 50 tests",
            iconName: "achievement_experienced",
            requirement: 50
        ),
        Achievement(
            id: "master",
            name: "Master Angler",
            description: "Complete 100 tests",
            iconName: "achievement_master",
            requirement: 100
        ),
        Achievement(
            id: "line_expert",
            name: "Line Expert",
            description: "Test all line types",
            iconName: "achievement_expert",
            requirement: 4
        ),
        Achievement(
            id: "knot_master",
            name: "Knot Master",
            description: "Complete all knot tutorials",
            iconName: "achievement_knot",
            requirement: 4
        ),
        Achievement(
            id: "economist",
            name: "Economist",
            description: "Find optimal line for 10 different fish",
            iconName: "achievement_economist",
            requirement: 10
        ),
        Achievement(
            id: "extremist",
            name: "Extremist",
            description: "Catch fish at over 95% load",
            iconName: "achievement_extreme",
            requirement: 1
        ),
        Achievement(
            id: "perfect_catch",
            name: "Perfect Catch",
            description: "Catch with exactly 50% safety margin",
            iconName: "achievement_perfect",
            requirement: 1
        ),
        Achievement(
            id: "trophy_hunter",
            name: "Trophy Hunter",
            description: "Catch 5 trophy fish",
            iconName: "achievement_trophy",
            requirement: 5
        ),
        Achievement(
            id: "scientist",
            name: "Scientist",
            description: "Complete all quizzes with 100%",
            iconName: "achievement_scientist",
            requirement: 1
        ),
        Achievement(
            id: "survivor",
            name: "Survivor",
            description: "Catch 10 fish in a row without breaking",
            iconName: "achievement_survivor",
            requirement: 10
        ),
        Achievement(
            id: "monster_catcher",
            name: "Monster Catcher",
            description: "Catch a fish over 50 lb",
            iconName: "achievement_monster",
            requirement: 1
        ),
    ]
    
    static func achievement(byId id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
