import SwiftUI

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool
    var style: ButtonStyle
    
    init(title: String, isDisabled: Bool = false, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.isDisabled = isDisabled
        self.style = style
        self.action = action
    }
    
    enum ButtonStyle {
        case primary
        case secondary
        case danger
        case success
        
        var gradient: LinearGradient {
            switch self {
            case .primary: return AppGradients.primary
            case .secondary: return LinearGradient(colors: [AppColors.textSecondary.opacity(0.2)], startPoint: .top, endPoint: .bottom)
            case .danger: return AppGradients.danger
            case .success: return AppGradients.success
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary, .danger, .success: return .white
            case .secondary: return AppColors.textPrimary
            }
        }
    }
    
    var body: some View {
        Button(action: {
            SoundManager.shared.playButton()
            action()
        }) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(isDisabled ? AppColors.textSecondary : style.textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    isDisabled 
                        ? AnyView(Color.gray.opacity(0.3))
                        : AnyView(style.gradient)
                )
                .cornerRadius(Constants.UI.cornerRadius)
                .shadow(color: isDisabled ? .clear : Color.black.opacity(0.15), radius: 8, y: 4)
        }
        .disabled(isDisabled)
    }
}

// MARK: - Icon Button
struct IconButton: View {
    let icon: AnyView
    let action: () -> Void
    var size: CGFloat = 44
    var backgroundColor: Color = AppColors.surface
    
    var body: some View {
        Button(action: {
            SoundManager.shared.playButton()
            action()
        }) {
            icon
                .frame(width: size * 0.5, height: size * 0.5)
                .foregroundColor(AppColors.primary)
                .frame(width: size, height: size)
                .background(backgroundColor)
                .cornerRadius(size / 2)
                .shadow(color: Color.black.opacity(0.1), radius: 4, y: 2)
        }
    }
}

// MARK: - Chip Button
struct ChipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            SoundManager.shared.playButton()
            action()
        }) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.primary : AppColors.surface)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.clear : AppColors.border, lineWidth: 1)
                )
        }
    }
}

// MARK: - Toggle Button
struct ToggleButton: View {
    let leftTitle: String
    let rightTitle: String
    @Binding var isRightSelected: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isRightSelected = false
                }
            }) {
                Text(leftTitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(!isRightSelected ? .white : AppColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(!isRightSelected ? AppColors.primary : Color.clear)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isRightSelected = true
                }
            }) {
                Text(rightTitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isRightSelected ? .white : AppColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(isRightSelected ? AppColors.primary : Color.clear)
            }
        }
        .background(AppColors.background)
        .cornerRadius(Constants.UI.smallCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.UI.smallCornerRadius)
                .stroke(AppColors.border, lineWidth: 1)
        )
    }
}
