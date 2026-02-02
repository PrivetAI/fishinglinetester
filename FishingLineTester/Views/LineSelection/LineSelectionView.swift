import SwiftUI

// MARK: - Line Selection View
struct LineSelectionView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedLineType: LineType = .monofilament
    @State private var diameter: Double = 0.20
    @State private var showSimulator = false
    
    var currentLine: FishingLine {
        FishingLine(type: selectedLineType, diameter: diameter)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                    
                    // Line Type Selection
                    lineTypeSection
                    
                    // Diameter Slider
                    diameterSection
                    
                    // Current Line Info
                    lineInfoSection
                    
                    // Test Button
                    PrimaryButton(title: "Test This Line") {
                        showSimulator = true
                    }
                    .padding(.horizontal, Constants.UI.screenPadding)
                    .padding(.top, 10)
                }
                .padding(.vertical, 16)
            }
            .background(AppColors.background)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showSimulator) {
                SimulatorView(line: currentLine)
                    .environmentObject(dataManager)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Line Strength Tester")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Select your fishing line to test")
                .font(.system(size: 15))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Line Type Section
    private var lineTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Line Type")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, Constants.UI.screenPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(LineType.allCases) { type in
                        LineTypeCard(
                            lineType: type,
                            isSelected: selectedLineType == type,
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedLineType = type
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, Constants.UI.screenPadding)
            }
        }
    }
    
    // MARK: - Diameter Section
    private var diameterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Diameter")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text(String(format: "%.2f mm", diameter))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primary)
            }
            
            // Visual thickness indicator
            DiameterVisualizer(diameter: diameter)
                .frame(height: 40)
            
            // Slider
            DiameterSlider(value: $diameter)
        }
        .padding(Constants.UI.cardPadding)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
        .padding(.horizontal, Constants.UI.screenPadding)
    }
    
    // MARK: - Line Info Section
    private var lineInfoSection: some View {
        VStack(spacing: 16) {
            // Strength display
            HStack(spacing: 20) {
                strengthCard(
                    title: "Strength",
                    value: currentLine.formattedStrengthLb,
                    subtitle: "pounds"
                )
                
                strengthCard(
                    title: "Strength",
                    value: currentLine.formattedStrengthKg,
                    subtitle: "kilograms"
                )
            }
            
            // Properties
            HStack(spacing: 12) {
                propertyTag("Stretch: \(selectedLineType.stretch.rawValue)")
                propertyTag("Visibility: \(selectedLineType.visibility.rawValue)")
            }
        }
        .padding(.horizontal, Constants.UI.screenPadding)
    }
    
    private func strengthCard(title: String, value: String, subtitle: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.primary)
            
            Text(subtitle)
                .font(.system(size: 11))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
    
    private func propertyTag(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13))
            .foregroundColor(AppColors.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppColors.background)
            .cornerRadius(15)
    }
}

// MARK: - Line Type Card
struct LineTypeCard: View {
    let lineType: LineType
    let isSelected: Bool
    let onTap: () -> Void
    
    private var lineColor: Color {
        switch lineType {
        case .monofilament: return AppColors.monofilament
        case .braided: return AppColors.braided
        case .fluorocarbon: return AppColors.fluorocarbon
        case .hybrid: return AppColors.hybrid
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Icon
                LineIcon(lineType: lineType)
                    .frame(width: 40, height: 40)
                
                // Name
                Text(lineType.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                // Short description
                Text(lineType.shortName)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(16)
            .frame(width: 130)
            .background(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                            .stroke(isSelected ? lineColor : Color.clear, lineWidth: 2)
                    )
            )
            .shadow(color: Color.black.opacity(isSelected ? 0.1 : 0.05), radius: isSelected ? 10 : 5, y: 2)
        }
    }
}

// MARK: - Diameter Visualizer
struct DiameterVisualizer: View {
    let diameter: Double
    
    private var normalizedThickness: CGFloat {
        let min = Constants.Line.minDiameter
        let max = Constants.Line.maxDiameter
        return CGFloat((diameter - min) / (max - min))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.background)
                    .frame(height: 8)
                
                // Actual line representation
                RoundedRectangle(cornerRadius: (normalizedThickness * 10 + 2) / 2)
                    .fill(AppColors.primary)
                    .frame(
                        width: geometry.size.width,
                        height: normalizedThickness * 20 + 4
                    )
            }
            .frame(maxHeight: .infinity)
        }
    }
}

// MARK: - Diameter Slider
struct DiameterSlider: View {
    @Binding var value: Double
    
    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.background)
                        .frame(height: 8)
                    
                    // Filled track
                    let progress = (value - Constants.Line.minDiameter) / (Constants.Line.maxDiameter - Constants.Line.minDiameter)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.primary)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                    
                    // Thumb
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 28, height: 28)
                        .shadow(color: AppColors.primary.opacity(0.3), radius: 4, y: 2)
                        .offset(x: geometry.size.width * CGFloat(progress) - 14)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let newProgress = gesture.location.x / geometry.size.width
                                    let clampedProgress = max(0, min(1, newProgress))
                                    let range = Constants.Line.maxDiameter - Constants.Line.minDiameter
                                    let rawValue = Constants.Line.minDiameter + range * Double(clampedProgress)
                                    // Snap to 0.02 increments
                                    value = round(rawValue / 0.02) * 0.02
                                }
                        )
                }
            }
            .frame(height: 28)
            
            // Labels
            HStack {
                Text("0.08mm")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                Text("0.60mm")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}
