import SwiftUI

// MARK: - App Colors
struct AppColors {
    // Primary palette
    static let primary = Color(hex: "1E88E5")
    static let primaryDark = Color(hex: "1565C0")
    static let primaryLight = Color(hex: "64B5F6")
    
    // Water colors
    static let waterDark = Color(hex: "0D47A1")
    static let waterLight = Color(hex: "42A5F5")
    static let waterSurface = Color(hex: "90CAF9")
    
    // Line colors
    static let monofilament = Color(hex: "B0BEC5")
    static let braided = Color(hex: "4CAF50")
    static let fluorocarbon = Color(hex: "00BCD4")
    static let hybrid = Color(hex: "9C27B0")
    
    // Status colors
    static let success = Color(hex: "4CAF50")
    static let warning = Color(hex: "FF9800")
    static let danger = Color(hex: "F44336")
    static let critical = Color(hex: "D32F2F")
    
    // UI colors
    static let background = Color(hex: "F5F7FA")
    static let surface = Color.white
    static let cardBackground = Color(hex: "FFFFFF")
    static let textPrimary = Color(hex: "212121")
    static let textSecondary = Color(hex: "757575")
    static let border = Color(hex: "E0E0E0")
    
    // Gauge colors
    static let gaugeSafe = Color(hex: "4CAF50")
    static let gaugeModerate = Color(hex: "8BC34A")
    static let gaugeWarning = Color(hex: "FFC107")
    static let gaugeDanger = Color(hex: "FF5722")
    static let gaugeCritical = Color(hex: "F44336")
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Gradients
struct AppGradients {
    static let water = LinearGradient(
        colors: [AppColors.waterSurface, AppColors.waterLight, AppColors.waterDark],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let primary = LinearGradient(
        colors: [AppColors.primaryLight, AppColors.primary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let success = LinearGradient(
        colors: [Color(hex: "66BB6A"), AppColors.success],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let danger = LinearGradient(
        colors: [Color(hex: "EF5350"), AppColors.danger],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
