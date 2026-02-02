import Foundation

// MARK: - Quiz Question
struct QuizQuestion: Codable, Identifiable {
    let id: UUID
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    
    init(id: UUID = UUID(), question: String, options: [String], correctIndex: Int, explanation: String) {
        self.id = id
        self.question = question
        self.options = options
        self.correctIndex = correctIndex
        self.explanation = explanation
    }
}

// MARK: - Quiz Database
struct QuizDatabase {
    static let questions: [QuizQuestion] = [
        QuizQuestion(
            question: "Which line can hold a 12 lb pike?",
            options: ["Mono 6 lb", "Mono 15 lb", "Mono 8 lb"],
            correctIndex: 1,
            explanation: "Always choose a line with at least 25% more strength than the target fish weight."
        ),
        QuizQuestion(
            question: "How much does a knot reduce line strength?",
            options: ["5-15%", "20-30%", "No reduction"],
            correctIndex: 0,
            explanation: "Knots create stress points that typically reduce strength by 5-15% depending on the knot type."
        ),
        QuizQuestion(
            question: "Which line is strongest for its diameter?",
            options: ["Monofilament", "Braided", "Fluorocarbon"],
            correctIndex: 1,
            explanation: "Braided line offers about 2x the strength per diameter compared to monofilament."
        ),
        QuizQuestion(
            question: "How often should you replace fishing line?",
            options: ["Every year", "Every 6 months of active use", "Never if stored properly"],
            correctIndex: 1,
            explanation: "UV exposure, abrasion, and stress weaken line over time. Replace every 6 months of regular use."
        ),
        QuizQuestion(
            question: "Which line is nearly invisible underwater?",
            options: ["Braided", "Monofilament", "Fluorocarbon"],
            correctIndex: 2,
            explanation: "Fluorocarbon has a refractive index similar to water, making it nearly invisible."
        ),
        QuizQuestion(
            question: "What happens to line strength in cold water?",
            options: ["Increases", "Decreases by ~5%", "Stays the same"],
            correctIndex: 1,
            explanation: "Cold water makes line stiffer and slightly weaker, reducing strength by about 5%."
        ),
        QuizQuestion(
            question: "How much safety margin should you have?",
            options: ["10%", "30-50%", "100%"],
            correctIndex: 1,
            explanation: "A 30-50% safety margin accounts for knots, wear, and sudden fish movements."
        ),
        QuizQuestion(
            question: "Which knot preserves the most strength?",
            options: ["Clinch knot", "Palomar knot", "Simple overhand"],
            correctIndex: 0,
            explanation: "The clinch knot loses only about 5% strength, best for maintaining line integrity."
        ),
        QuizQuestion(
            question: "What advantage does stretch in mono provide?",
            options: ["Makes casting easier", "Absorbs shock from fish strikes", "Increases strength"],
            correctIndex: 1,
            explanation: "The stretch in monofilament acts like a shock absorber, protecting against sudden jerks."
        ),
        QuizQuestion(
            question: "Why is braided line visible in water?",
            options: ["It's always coloured", "It reflects light differently", "It's thicker"],
            correctIndex: 1,
            explanation: "The woven structure of braided line reflects light differently than water, making it visible."
        ),
        QuizQuestion(
            question: "What's the main disadvantage of fluorocarbon?",
            options: ["Low strength", "High visibility", "Memory (coils easily)"],
            correctIndex: 2,
            explanation: "Fluorocarbon is stiffer and tends to 'remember' being coiled, causing tangles."
        ),
        QuizQuestion(
            question: "How much extra load do aggressive fish movements add?",
            options: ["10%", "Up to 50%", "200%"],
            correctIndex: 1,
            explanation: "Sudden, aggressive movements can increase effective load on the line by up to 50%."
        ),
        QuizQuestion(
            question: "Best line type for trophy fish?",
            options: ["Monofilament", "Braided", "Fluorocarbon"],
            correctIndex: 1,
            explanation: "Braided line's superior strength-to-diameter ratio is ideal for large, powerful fish."
        ),
        QuizQuestion(
            question: "Does wet line differ from dry line?",
            options: ["Wet is 10-15% stronger", "Dry is stronger", "No difference"],
            correctIndex: 0,
            explanation: "Wet line is actually 10-15% stronger due to the lubricating effect of water."
        ),
        QuizQuestion(
            question: "What's the best line for beginners?",
            options: ["Braided", "Monofilament", "Fluorocarbon"],
            correctIndex: 1,
            explanation: "Monofilament is forgiving, affordable, and easy to handle, perfect for learning."
        ),
    ]
    
    static func randomQuestions(count: Int) -> [QuizQuestion] {
        Array(questions.shuffled().prefix(count))
    }
}

// MARK: - Quiz Result
struct QuizResult: Codable, Identifiable {
    let id: UUID
    let totalQuestions: Int
    let correctAnswers: Int
    let timestamp: Date
    
    var score: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions)
    }
    
    var formattedScore: String {
        "\(correctAnswers)/\(totalQuestions)"
    }
    
    var percentageScore: String {
        String(format: "%.0f%%", score * 100)
    }
    
    var isPerfect: Bool {
        correctAnswers == totalQuestions
    }
    
    init(id: UUID = UUID(), totalQuestions: Int, correctAnswers: Int) {
        self.id = id
        self.totalQuestions = totalQuestions
        self.correctAnswers = correctAnswers
        self.timestamp = Date()
    }
}
