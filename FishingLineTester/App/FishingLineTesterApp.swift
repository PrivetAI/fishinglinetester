import SwiftUI

@main
struct FishingLineTesterApp: App {
    @StateObject private var dataManager = DataManager()
    
    init() {
        // Force light appearance to avoid theme changes
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(dataManager)
                .preferredColorScheme(.light)
        }
    }
}
