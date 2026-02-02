import Foundation
import Combine

// MARK: - Data Manager
final class DataManager: ObservableObject {
    // MARK: - Published Properties
    @Published var testHistory: [SimulationResult] = []
    @Published var achievements: [Achievement] = []
    @Published var savedCombinations: [SavedCombination] = []
    @Published var statistics: TestStatistics = TestStatistics()
    @Published var quizResults: [QuizResult] = []
    @Published var useMetric: Bool = false
    @Published var soundEnabled: Bool = true
    
    // MARK: - Private Properties
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Achievement Tracking
    private var consecutiveSuccesses: Int = 0
    private var testedLineTypes: Set<LineType> = []
    
    // MARK: - Initialization
    init() {
        loadAllData()
    }
    
    // MARK: - Test History
    func addTestResult(_ result: SimulationResult) {
        testHistory.insert(result, at: 0)
        
        // Limit history to 1000 entries
        if testHistory.count > 1000 {
            testHistory = Array(testHistory.prefix(1000))
        }
        
        // Update statistics
        statistics.update(with: result)
        
        // Check achievements
        checkAchievements(for: result)
        
        // Track consecutive successes
        if result.success {
            consecutiveSuccesses += 1
        } else {
            consecutiveSuccesses = 0
        }
        
        // Track line types tested
        testedLineTypes.insert(result.line.type)
        
        saveTestHistory()
        saveStatistics()
        saveAchievements()
    }
    
    func clearHistory() {
        testHistory.removeAll()
        statistics = TestStatistics()
        consecutiveSuccesses = 0
        testedLineTypes.removeAll()
        saveTestHistory()
        saveStatistics()
    }
    
    // MARK: - Saved Combinations
    func saveCombination(_ combination: SavedCombination) {
        savedCombinations.append(combination)
        saveSavedCombinations()
    }
    
    func deleteCombination(_ combination: SavedCombination) {
        savedCombinations.removeAll { $0.id == combination.id }
        saveSavedCombinations()
    }
    
    func updateCombination(_ combination: SavedCombination) {
        if let index = savedCombinations.firstIndex(where: { $0.id == combination.id }) {
            savedCombinations[index] = combination
            saveSavedCombinations()
        }
    }
    
    // MARK: - Quiz Results
    func addQuizResult(_ result: QuizResult) {
        quizResults.insert(result, at: 0)
        
        // Check for perfect score achievement
        if result.isPerfect {
            updateAchievementProgress(id: "scientist", progress: 1)
        }
        
        saveQuizResults()
        saveAchievements()
    }
    
    // MARK: - Achievements
    private func checkAchievements(for result: SimulationResult) {
        // Beginner, Experienced, Master
        updateAchievementProgress(id: "beginner", progress: statistics.totalTests)
        updateAchievementProgress(id: "experienced", progress: statistics.totalTests)
        updateAchievementProgress(id: "master", progress: statistics.totalTests)
        
        // Line Expert
        updateAchievementProgress(id: "line_expert", progress: testedLineTypes.count)
        
        // Extremist (catch at >95% load)
        if result.success && result.loadPercentage >= 0.95 {
            updateAchievementProgress(id: "extremist", progress: 1)
        }
        
        // Perfect Catch (exactly 50% margin, with 5% tolerance)
        if result.success && abs(result.safetyMargin - 0.5) < 0.05 {
            updateAchievementProgress(id: "perfect_catch", progress: 1)
        }
        
        // Trophy Hunter
        let fishCategory = FishDatabase.allFish.first { $0.name == result.fishName }?.category
        if result.success && fishCategory == .trophy {
            let trophyCatches = testHistory.filter { 
                $0.success && FishDatabase.allFish.first { f in f.name == $0.fishName }?.category == .trophy
            }.count
            updateAchievementProgress(id: "trophy_hunter", progress: trophyCatches)
        }
        
        // Survivor
        updateAchievementProgress(id: "survivor", progress: consecutiveSuccesses)
        
        // Monster Catcher
        if result.success && result.fishWeight >= 50 {
            updateAchievementProgress(id: "monster_catcher", progress: 1)
        }
    }
    
    private func updateAchievementProgress(id: String, progress: Int) {
        if let index = achievements.firstIndex(where: { $0.id == id }) {
            achievements[index].updateProgress(progress)
        }
    }
    
    func resetAchievements() {
        achievements = AchievementDefinitions.all
        saveAchievements()
    }
    
    // MARK: - Settings
    func toggleUnits() {
        useMetric.toggle()
        defaults.set(useMetric, forKey: Constants.StorageKeys.unitPreference)
    }
    
    func toggleSound() {
        soundEnabled.toggle()
        defaults.set(soundEnabled, forKey: Constants.StorageKeys.soundEnabled)
    }
    
    // MARK: - Persistence
    private func loadAllData() {
        loadTestHistory()
        loadAchievements()
        loadSavedCombinations()
        loadStatistics()
        loadQuizResults()
        loadSettings()
    }
    
    private func loadTestHistory() {
        if let data = defaults.data(forKey: Constants.StorageKeys.testHistory),
           let history = try? decoder.decode([SimulationResult].self, from: data) {
            testHistory = history
        }
    }
    
    private func saveTestHistory() {
        if let data = try? encoder.encode(testHistory) {
            defaults.set(data, forKey: Constants.StorageKeys.testHistory)
        }
    }
    
    private func loadAchievements() {
        if let data = defaults.data(forKey: Constants.StorageKeys.achievements),
           let saved = try? decoder.decode([Achievement].self, from: data) {
            achievements = saved
        } else {
            achievements = AchievementDefinitions.all
        }
    }
    
    private func saveAchievements() {
        if let data = try? encoder.encode(achievements) {
            defaults.set(data, forKey: Constants.StorageKeys.achievements)
        }
    }
    
    private func loadSavedCombinations() {
        if let data = defaults.data(forKey: Constants.StorageKeys.savedCombinations),
           let saved = try? decoder.decode([SavedCombination].self, from: data) {
            savedCombinations = saved
        }
    }
    
    private func saveSavedCombinations() {
        if let data = try? encoder.encode(savedCombinations) {
            defaults.set(data, forKey: Constants.StorageKeys.savedCombinations)
        }
    }
    
    private func loadStatistics() {
        if let data = defaults.data(forKey: Constants.StorageKeys.statistics),
           let saved = try? decoder.decode(TestStatistics.self, from: data) {
            statistics = saved
        }
    }
    
    private func saveStatistics() {
        if let data = try? encoder.encode(statistics) {
            defaults.set(data, forKey: Constants.StorageKeys.statistics)
        }
    }
    
    private func loadQuizResults() {
        if let data = defaults.data(forKey: "quizResults"),
           let saved = try? decoder.decode([QuizResult].self, from: data) {
            quizResults = saved
        }
    }
    
    private func saveQuizResults() {
        if let data = try? encoder.encode(quizResults) {
            defaults.set(data, forKey: "quizResults")
        }
    }
    
    private func loadSettings() {
        useMetric = defaults.bool(forKey: Constants.StorageKeys.unitPreference)
        soundEnabled = defaults.object(forKey: Constants.StorageKeys.soundEnabled) as? Bool ?? true
    }
}
