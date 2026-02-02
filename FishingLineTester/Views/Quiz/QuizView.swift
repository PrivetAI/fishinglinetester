import SwiftUI

// MARK: - Quiz View
struct QuizView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var questions: [QuizQuestion] = []
    @State private var currentIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showExplanation = false
    @State private var correctAnswers = 0
    @State private var quizComplete = false
    @State private var quizStarted = false
    
    let questionCount = 10
    
    var body: some View {
        VStack(spacing: 0) {
            if !quizStarted {
                quizIntro
            } else if quizComplete {
                quizResults
            } else {
                quizQuestion
            }
        }
        .background(AppColors.background)
    }
    
    // MARK: - Quiz Intro
    private var quizIntro: some View {
        VStack(spacing: 30) {
            Spacer()
            
            BookIcon()
                .frame(width: 80, height: 80)
                .foregroundColor(AppColors.primary)
            
            VStack(spacing: 8) {
                Text("Knowledge Quiz")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Test your fishing line knowledge!")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            VStack(spacing: 12) {
                infoRow("questions_count", "\(questionCount) questions")
                infoRow("time", "No time limit")
                infoRow("scoring", "See explanations for wrong answers")
            }
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(Constants.UI.cornerRadius)
            .padding(.horizontal, Constants.UI.screenPadding)
            
            Spacer()
            
            PrimaryButton(title: "Start Quiz") {
                startQuiz()
            }
            .padding(.horizontal, Constants.UI.screenPadding)
            .padding(.bottom, 30)
        }
    }
    
    private func infoRow(_ icon: String, _ text: String) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(AppColors.primary.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    CheckmarkIcon()
                        .frame(width: 16, height: 16)
                        .foregroundColor(AppColors.primary)
                )
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
    }
    
    // MARK: - Quiz Question
    private var quizQuestion: some View {
        VStack(spacing: 0) {
            // Progress header
            VStack(spacing: 8) {
                HStack {
                    Text("Question \(currentIndex + 1)/\(questions.count)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Text("\(correctAnswers) correct")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.success)
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.background)
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.primary)
                            .frame(width: geometry.size.width * CGFloat(currentIndex + 1) / CGFloat(questions.count), height: 8)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, Constants.UI.screenPadding)
            .padding(.vertical, 16)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Question
                    if currentIndex < questions.count {
                        let question = questions[currentIndex]
                        
                        Text(question.question)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Constants.UI.screenPadding)
                        
                        // Options
                        VStack(spacing: 12) {
                            ForEach(question.options.indices, id: \.self) { index in
                                AnswerButton(
                                    text: question.options[index],
                                    isSelected: selectedAnswer == index,
                                    isCorrect: showExplanation ? index == question.correctIndex : nil,
                                    isWrong: showExplanation && selectedAnswer == index && index != question.correctIndex,
                                    action: {
                                        if !showExplanation {
                                            selectAnswer(index)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, Constants.UI.screenPadding)
                        
                        // Explanation
                        if showExplanation {
                            VStack(spacing: 12) {
                                HStack {
                                    if selectedAnswer == question.correctIndex {
                                        CheckmarkIcon()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(AppColors.success)
                                        
                                        Text("Correct!")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.success)
                                    } else {
                                        CrossIcon()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(AppColors.danger)
                                        
                                        Text("Wrong")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.danger)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Text(question.explanation)
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.textSecondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .background(AppColors.cardBackground)
                            .cornerRadius(Constants.UI.cornerRadius)
                            .padding(.horizontal, Constants.UI.screenPadding)
                            
                            PrimaryButton(
                                title: currentIndex < questions.count - 1 ? "Next Question" : "See Results",
                                action: nextQuestion
                            )
                            .padding(.horizontal, Constants.UI.screenPadding)
                            .padding(.top, 10)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - Quiz Results
    private var quizResults: some View {
        ScrollView {
            VStack(spacing: 30) {
                Spacer().frame(height: 40)
                
                // Score circle
                ZStack {
                    Circle()
                        .stroke(AppColors.background, lineWidth: 12)
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(correctAnswers) / CGFloat(questions.count))
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 4) {
                        Text("\(correctAnswers)/\(questions.count)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(scoreMessage)
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                // Message
                Text(detailedMessage)
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Constants.UI.screenPadding)
                
                // Stats
                HStack(spacing: 16) {
                    resultStat("Correct", "\(correctAnswers)", AppColors.success)
                    resultStat("Wrong", "\(questions.count - correctAnswers)", AppColors.danger)
                    resultStat("Score", String(format: "%.0f%%", Double(correctAnswers) / Double(questions.count) * 100), AppColors.primary)
                }
                .padding(.horizontal, Constants.UI.screenPadding)
                
                // Buttons
                VStack(spacing: 12) {
                    PrimaryButton(title: "Try Again") {
                        startQuiz()
                    }
                    
                    PrimaryButton(title: "Done", style: .secondary) {
                        quizStarted = false
                        quizComplete = false
                    }
                }
                .padding(.horizontal, Constants.UI.screenPadding)
            }
        }
    }
    
    private var scoreColor: Color {
        let ratio = Double(correctAnswers) / Double(questions.count)
        if ratio >= 0.8 { return AppColors.success }
        if ratio >= 0.5 { return AppColors.warning }
        return AppColors.danger
    }
    
    private var scoreMessage: String {
        let ratio = Double(correctAnswers) / Double(questions.count)
        if ratio >= 0.8 { return "Excellent!" }
        if ratio >= 0.6 { return "Good job!" }
        if ratio >= 0.4 { return "Not bad" }
        return "Keep learning"
    }
    
    private var detailedMessage: String {
        let ratio = Double(correctAnswers) / Double(questions.count)
        if ratio == 1.0 { return "Perfect score! You're a fishing line expert!" }
        if ratio >= 0.8 { return "Great knowledge! You know your lines well." }
        if ratio >= 0.6 { return "Good understanding. Review the Knowledge Base to improve." }
        if ratio >= 0.4 { return "You're learning. Check out the Tips section for more info." }
        return "Time to study! Visit the Knowledge Base to learn more."
    }
    
    private func resultStat(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
    }
    
    // MARK: - Actions
    private func startQuiz() {
        questions = QuizDatabase.randomQuestions(count: questionCount)
        currentIndex = 0
        selectedAnswer = nil
        showExplanation = false
        correctAnswers = 0
        quizComplete = false
        quizStarted = true
    }
    
    private func selectAnswer(_ index: Int) {
        selectedAnswer = index
        showExplanation = true
        
        if index == questions[currentIndex].correctIndex {
            correctAnswers += 1
            SoundManager.shared.playSuccess()
        } else {
            SoundManager.shared.playFail()
        }
    }
    
    private func nextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            selectedAnswer = nil
            showExplanation = false
        } else {
            // Save result
            let result = QuizResult(totalQuestions: questions.count, correctAnswers: correctAnswers)
            dataManager.addQuizResult(result)
            quizComplete = true
        }
    }
}

// MARK: - Answer Button
struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let isWrong: Bool
    let action: () -> Void
    
    private var backgroundColor: Color {
        if let correct = isCorrect {
            if correct {
                return AppColors.success.opacity(0.2)
            } else if isWrong {
                return AppColors.danger.opacity(0.2)
            }
        }
        return isSelected ? AppColors.primary.opacity(0.1) : AppColors.cardBackground
    }
    
    private var borderColor: Color {
        if let correct = isCorrect {
            if correct {
                return AppColors.success
            } else if isWrong {
                return AppColors.danger
            }
        }
        return isSelected ? AppColors.primary : AppColors.border
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let correct = isCorrect {
                    if correct {
                        CheckmarkIcon()
                            .frame(width: 20, height: 20)
                            .foregroundColor(AppColors.success)
                    } else if isWrong {
                        CrossIcon()
                            .frame(width: 20, height: 20)
                            .foregroundColor(AppColors.danger)
                    }
                }
            }
            .padding(16)
            .background(backgroundColor)
            .cornerRadius(Constants.UI.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
    }
}
