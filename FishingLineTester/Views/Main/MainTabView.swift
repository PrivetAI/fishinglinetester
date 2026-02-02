import SwiftUI

// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab: Tab = .test
    @EnvironmentObject var dataManager: DataManager
    
    enum Tab: String, CaseIterable {
        case test
        case knowledge
        case calculator
        case history
        case achievements
        
        var title: String {
            switch self {
            case .test: return "Test"
            case .knowledge: return "Learn"
            case .calculator: return "Calculate"
            case .history: return "History"
            case .achievements: return "Awards"
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Content
                Group {
                    switch selectedTab {
                    case .test:
                        LineSelectionView()
                    case .knowledge:
                        KnowledgeBaseView()
                    case .calculator:
                        CalculatorView()
                    case .history:
                        HistoryView()
                    case .achievements:
                        AchievementsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 80)
                
                // Custom Tab Bar
                CustomTabBar(selectedTab: $selectedTab)
                    .frame(height: 80)
            }
            .background(AppColors.background)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: MainTabView.Tab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MainTabView.Tab.allCases, id: \.rawValue) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                        SoundManager.shared.playButton()
                    }
                )
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(
            AppColors.surface
                .shadow(color: Color.black.opacity(0.1), radius: 10, y: -5)
        )
    }
}

// MARK: - Tab Bar Item
struct TabBarItem: View {
    let tab: MainTabView.Tab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                tabIcon
                    .frame(width: 24, height: 24)
                
                Text(tab.title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    var tabIcon: some View {
        switch tab {
        case .test:
            CustomIcons.TabIcons.test(selected: isSelected)
        case .knowledge:
            CustomIcons.TabIcons.knowledge(selected: isSelected)
        case .calculator:
            CustomIcons.TabIcons.calculator(selected: isSelected)
        case .history:
            CustomIcons.TabIcons.history(selected: isSelected)
        case .achievements:
            CustomIcons.TabIcons.achievements(selected: isSelected)
        }
    }
}
