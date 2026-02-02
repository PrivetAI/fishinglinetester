import SwiftUI

// MARK: - Achievements View
struct AchievementsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    private var unlockedCount: Int {
        dataManager.achievements.filter { $0.unlocked }.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            ScrollView {
                VStack(spacing: 16) {
                    // Progress overview
                    progressOverview
                    
                    // Achievement grid
                    achievementGrid
                }
                .padding(.horizontal, Constants.UI.screenPadding)
                .padding(.bottom, 20)
            }
        }
        .background(AppColors.background)
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Achievements")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("\(unlockedCount)/\(dataManager.achievements.count) unlocked")
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Progress Overview
    private var progressOverview: some View {
        VStack(spacing: 12) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.background)
                        .frame(height: 16)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.primaryLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(unlockedCount) / CGFloat(dataManager.achievements.count), height: 16)
                }
            }
            .frame(height: 16)
            
            // Trophy count
            HStack(spacing: 20) {
                trophyCounter(
                    count: dataManager.achievements.filter { $0.unlocked }.count,
                    color: Color(hex: "FFD700"),
                    label: "Unlocked"
                )
                
                trophyCounter(
                    count: dataManager.achievements.filter { !$0.unlocked && $0.progressPercentage > 0 }.count,
                    color: AppColors.warning,
                    label: "In Progress"
                )
                
                trophyCounter(
                    count: dataManager.achievements.filter { !$0.unlocked && $0.progressPercentage == 0 }.count,
                    color: AppColors.textSecondary,
                    label: "Locked"
                )
            }
        }
        .padding(Constants.UI.cardPadding)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
    
    private func trophyCounter(count: Int, color: Color, label: String) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                TrophyIcon()
                    .frame(width: 16, height: 16)
                    .foregroundColor(color)
                
                Text("\(count)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Achievement Grid
    private var achievementGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(dataManager.achievements) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
    }
}

// MARK: - Achievement Card
struct AchievementCard: View {
    let achievement: Achievement
    
    private var backgroundColor: Color {
        if achievement.unlocked {
            return Color(hex: "FFF8E1") // Light gold
        }
        return AppColors.cardBackground
    }
    
    private var iconColor: Color {
        if achievement.unlocked {
            return Color(hex: "FFD700") // Gold
        }
        if achievement.progressPercentage > 0 {
            return AppColors.warning
        }
        return AppColors.textSecondary.opacity(0.5)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                TrophyIcon()
                    .frame(width: 28, height: 28)
                    .foregroundColor(iconColor)
                
                // Locked overlay
                if !achievement.unlocked && achievement.progressPercentage == 0 {
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 56, height: 56)
                }
            }
            
            // Name
            Text(achievement.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(achievement.unlocked ? AppColors.textPrimary : AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Description
            Text(achievement.description)
                .font(.system(size: 11))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Progress or unlocked badge
            if achievement.unlocked {
                HStack(spacing: 4) {
                    CheckmarkIcon()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color(hex: "FFD700"))
                    
                    Text("Unlocked")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(hex: "FFD700"))
                }
            } else {
                // Progress bar
                VStack(spacing: 4) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(AppColors.background)
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 3)
                                .fill(AppColors.primary)
                                .frame(width: geometry.size.width * achievement.progressPercentage, height: 6)
                        }
                    }
                    .frame(height: 6)
                    
                    Text(achievement.formattedProgress)
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(Constants.UI.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(achievement.unlocked ? iconColor.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(achievement.unlocked ? 0.08 : 0.03), radius: achievement.unlocked ? 8 : 4, y: 2)
    }
}
