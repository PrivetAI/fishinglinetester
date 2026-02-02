import SwiftUI

// MARK: - Info Card
struct InfoCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = Constants.UI.cardPadding
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    init(padding: CGFloat, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(AppColors.cardBackground)
            .cornerRadius(Constants.UI.cornerRadius)
            .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Titled Card
struct TitledCard<Content: View>: View {
    let title: String
    let content: Content
    var icon: AnyView? = nil
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    init(title: String, icon: AnyView?, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                if let icon = icon {
                    icon
                        .frame(width: 20, height: 20)
                        .foregroundColor(AppColors.primary)
                }
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            content
        }
        .padding(Constants.UI.cardPadding)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Statistic Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: AnyView
    var valueColor: Color = AppColors.primary
    
    var body: some View {
        VStack(spacing: 8) {
            icon
                .frame(width: 28, height: 28)
                .foregroundColor(AppColors.primary)
            
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(valueColor)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Progress Card
struct ProgressCard: View {
    let title: String
    let progress: Double
    let subtitle: String
    var color: Color = AppColors.primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.background)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * min(progress, 1.0), height: 8)
                }
            }
            .frame(height: 8)
            
            Text(subtitle)
                .font(.system(size: 12))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(Constants.UI.cardPadding)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - List Row Card
struct ListRowCard: View {
    let title: String
    let subtitle: String
    let icon: AnyView
    var trailing: AnyView? = nil
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 12) {
                icon
                    .frame(width: 40, height: 40)
                    .foregroundColor(AppColors.primary)
                    .background(AppColors.primaryLight.opacity(0.2))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                if let trailing = trailing {
                    trailing
                } else if onTap != nil {
                    ArrowRightIcon()
                        .frame(width: 16, height: 16)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(12)
            .background(AppColors.cardBackground)
            .cornerRadius(Constants.UI.cornerRadius)
            .shadow(color: Color.black.opacity(0.03), radius: 4, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
