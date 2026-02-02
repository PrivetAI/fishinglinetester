import SwiftUI

// MARK: - History View
struct HistoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab: HistoryTab = .tests
    
    enum HistoryTab: String, CaseIterable {
        case tests = "Tests"
        case stats = "Statistics"
        case quiz = "Quiz"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            // Tab picker
            tabPicker
            
            // Content
            switch selectedTab {
            case .tests:
                testsTab
            case .stats:
                statsTab
            case .quiz:
                quizTab
            }
        }
        .background(AppColors.background)
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("History")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Your fishing test journal")
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Tab Picker
    private var tabPicker: some View {
        HStack(spacing: 8) {
            ForEach(HistoryTab.allCases, id: \.rawValue) { tab in
                ChipButton(
                    title: tab.rawValue,
                    isSelected: selectedTab == tab,
                    action: { selectedTab = tab }
                )
            }
        }
        .padding(.horizontal, Constants.UI.screenPadding)
        .padding(.bottom, 16)
    }
    
    // MARK: - Tests Tab
    private var testsTab: some View {
        Group {
            if dataManager.testHistory.isEmpty {
                emptyState(
                    icon: AnyView(TestIcon().frame(width: 60, height: 60)),
                    title: "No Tests Yet",
                    subtitle: "Start testing lines to see your history here"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(dataManager.testHistory.prefix(100)) { result in
                            TestHistoryCard(result: result)
                        }
                    }
                    .padding(.horizontal, Constants.UI.screenPadding)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    // MARK: - Stats Tab
    private var statsTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Main stats
                HStack(spacing: 12) {
                    StatCard(
                        title: "Total Tests",
                        value: "\(dataManager.statistics.totalTests)",
                        icon: AnyView(TestIcon().frame(width: 20, height: 20))
                    )
                    
                    StatCard(
                        title: "Success Rate",
                        value: dataManager.statistics.formattedSuccessRate,
                        icon: AnyView(CheckmarkIcon().frame(width: 20, height: 20)),
                        valueColor: AppColors.success
                    )
                }
                
                HStack(spacing: 12) {
                    StatCard(
                        title: "Catches",
                        value: "\(dataManager.statistics.successfulTests)",
                        icon: AnyView(FishIcon().frame(width: 20, height: 20)),
                        valueColor: AppColors.success
                    )
                    
                    StatCard(
                        title: "Line Breaks",
                        value: "\(dataManager.statistics.failedTests)",
                        icon: AnyView(CrossIcon().frame(width: 20, height: 20)),
                        valueColor: AppColors.danger
                    )
                }
                
                // Records
                if dataManager.statistics.largestCatchWeightLb > 0 {
                    TitledCard(title: "Records") {
                        VStack(spacing: 12) {
                            recordRow(
                                "Largest Catch",
                                String(format: "%.1f lb (%@)", dataManager.statistics.largestCatchWeightLb, dataManager.statistics.largestCatchFishName)
                            )
                            
                            if dataManager.statistics.closestCallPercentage > 0 {
                                recordRow(
                                    "Closest Call",
                                    String(format: "%.1f%% load", dataManager.statistics.closestCallPercentage * 100)
                                )
                            }
                            
                            if dataManager.statistics.highestSafetyMargin > 0 {
                                recordRow(
                                    "Best Safety Margin",
                                    String(format: "%.0f%%", dataManager.statistics.highestSafetyMargin * 100)
                                )
                            }
                            
                            if let mostUsed = dataManager.statistics.mostUsedLineType {
                                recordRow("Most Used Line", mostUsed.name)
                            }
                        }
                    }
                }
                
                // Clear button
                if dataManager.statistics.totalTests > 0 {
                    Button(action: {
                        dataManager.clearHistory()
                    }) {
                        Text("Clear History")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.danger)
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, Constants.UI.screenPadding)
            .padding(.bottom, 20)
        }
    }
    
    private func recordRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
        }
    }
    
    // MARK: - Quiz Tab
    private var quizTab: some View {
        Group {
            if dataManager.quizResults.isEmpty {
                emptyState(
                    icon: AnyView(BookIcon().frame(width: 60, height: 60)),
                    title: "No Quiz Results",
                    subtitle: "Take a quiz to see your results here"
                )
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        // Average score
                        let avgScore = dataManager.quizResults.reduce(0.0) { $0 + $1.score } / Double(dataManager.quizResults.count)
                        
                        HStack(spacing: 12) {
                            StatCard(
                                title: "Quizzes Taken",
                                value: "\(dataManager.quizResults.count)",
                                icon: AnyView(BookIcon().frame(width: 20, height: 20))
                            )
                            
                            StatCard(
                                title: "Average Score",
                                value: String(format: "%.0f%%", avgScore * 100),
                                icon: AnyView(TrophyIcon().frame(width: 20, height: 20)),
                                valueColor: AppColors.primary
                            )
                        }
                        
                        // Quiz history
                        ForEach(dataManager.quizResults) { result in
                            QuizResultCard(result: result)
                        }
                    }
                    .padding(.horizontal, Constants.UI.screenPadding)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    // MARK: - Empty State
    private func emptyState(icon: AnyView, title: String, subtitle: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            
            icon
                .foregroundColor(AppColors.textSecondary)
            
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, Constants.UI.screenPadding)
    }
}

// MARK: - Test History Card
struct TestHistoryCard: View {
    let result: SimulationResult
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Status icon
            ZStack {
                Circle()
                    .fill(result.success ? AppColors.success.opacity(0.2) : AppColors.danger.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                if result.success {
                    CheckmarkIcon()
                        .frame(width: 20, height: 20)
                        .foregroundColor(AppColors.success)
                } else {
                    CrossIcon()
                        .frame(width: 20, height: 20)
                        .foregroundColor(AppColors.danger)
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(result.fishName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(result.line.type.shortName) \(result.line.formattedDiameter)")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            // Result
            VStack(alignment: .trailing, spacing: 4) {
                Text(result.formattedLoadPercentage)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(result.success ? AppColors.success : AppColors.danger)
                
                Text(dateFormatter.string(from: result.timestamp))
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.03), radius: 4, y: 2)
    }
}

// MARK: - Quiz Result Card
struct QuizResultCard: View {
    let result: QuizResult
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Score circle
            ZStack {
                Circle()
                    .stroke(AppColors.background, lineWidth: 4)
                    .frame(width: 44, height: 44)
                
                Circle()
                    .trim(from: 0, to: result.score)
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(-90))
                
                Text(result.percentageScore)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(result.formattedScore)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(dateFormatter.string(from: result.timestamp))
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            if result.isPerfect {
                TrophyIcon()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: "FFD700"))
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.03), radius: 4, y: 2)
    }
    
    private var scoreColor: Color {
        if result.score >= 0.8 { return AppColors.success }
        if result.score >= 0.5 { return AppColors.warning }
        return AppColors.danger
    }
}
