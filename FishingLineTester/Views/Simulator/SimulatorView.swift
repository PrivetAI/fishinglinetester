import SwiftUI

// MARK: - Simulator View
struct SimulatorView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    let line: FishingLine
    
    @State private var selectedFish: Fish?
    @State private var selectedCategory: FishCategory = .medium
    @State private var customWeight: Double = 5.0
    @State private var useCustomWeight = false
    
    // Simulation state
    @State private var isSimulating = false
    @State private var simulationProgress: Double = 0
    @State private var currentResult: SimulationResult?
    @State private var showResult = false
    
    // Advanced factors
    @State private var showAdvancedOptions = false
    @State private var selectedKnot: KnotType = .none
    @State private var selectedWear: LineWear = .new
    @State private var selectedFightIntensity: FightIntensity = .calm
    @State private var coldWater = false
    
    var currentFactors: SimulationFactors {
        SimulationFactors(
            knot: selectedKnot,
            wear: selectedWear,
            fightIntensity: selectedFightIntensity,
            coldWater: coldWater
        )
    }
    
    var body: some View {
        ZStack {
            // Background
            AppColors.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                simulatorHeader
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Simulation visual
                        simulationVisual
                        
                        // Line info
                        lineInfoCard
                        
                        // Fish selection
                        fishSelectionSection
                        
                        // Advanced options
                        advancedOptionsSection
                        
                        // Start button
                        if !isSimulating {
                            PrimaryButton(
                                title: selectedFish != nil ? "Start Fishing!" : "Select a Fish First",
                                action: startSimulation,
                                isDisabled: selectedFish == nil
                            )
                            .padding(.horizontal, Constants.UI.screenPadding)
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            
            // Result overlay
            if showResult, let result = currentResult {
                resultOverlay(result: result)
            }
        }
    }
    
    // MARK: - Header
    private var simulatorHeader: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                ArrowLeftIcon()
                    .frame(width: 24, height: 24)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Spacer()
            
            Text("Fishing Simulator")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            // Placeholder for symmetry
            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, Constants.UI.screenPadding)
        .padding(.vertical, 12)
        .background(AppColors.surface)
    }
    
    // MARK: - Simulation Visual
    private var simulationVisual: some View {
        ZStack {
            // Water background
            WaterView()
            
            // Bubbles
            BubbleView()
            
            // Rod
            RodAnimationView(
                loadPercentage: simulationProgress,
                isAnimating: isSimulating
            )
            .frame(width: 120, height: 100)
            .position(x: 80, y: 50)
            
            // Line
            LineAnimationView(
                loadPercentage: simulationProgress,
                isAnimating: isSimulating,
                isBroken: currentResult?.success == false && showResult
            )
            .frame(width: 100, height: 200)
            .position(x: UIScreen.main.bounds.width / 2, y: 150)
            
            // Fish
            if let fish = selectedFish {
                FishAnimationView(
                    fishName: fish.name,
                    isAnimating: isSimulating,
                    isCaught: currentResult?.success == true && showResult,
                    isEscaping: currentResult?.success == false && showResult
                )
            }
            
            // Tension gauge
            VStack {
                Spacer()
                TensionGauge(percentage: simulationProgress)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
        }
        .frame(height: 300)
        .cornerRadius(Constants.UI.cornerRadius)
        .padding(.horizontal, Constants.UI.screenPadding)
    }
    
    // MARK: - Line Info Card
    private var lineInfoCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Line")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(line.type.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(line.formattedDiameter)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(line.formattedStrengthLb)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding(Constants.UI.cardPadding)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
        .padding(.horizontal, Constants.UI.screenPadding)
    }
    
    // MARK: - Fish Selection
    private var fishSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Fish")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, Constants.UI.screenPadding)
            
            // Category picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(FishCategory.allCases, id: \.rawValue) { category in
                        ChipButton(
                            title: category.rawValue,
                            isSelected: selectedCategory == category,
                            action: {
                                selectedCategory = category
                                selectedFish = nil
                            }
                        )
                    }
                }
                .padding(.horizontal, Constants.UI.screenPadding)
            }
            
            // Fish list
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(FishDatabase.fish(forCategory: selectedCategory)) { fish in
                        FishCard(
                            fish: fish,
                            isSelected: selectedFish?.id == fish.id,
                            onTap: {
                                selectedFish = fish
                                customWeight = fish.randomWeight()
                            }
                        )
                    }
                    
                    // Random button
                    Button(action: {
                        selectedFish = FishDatabase.randomFish(inCategory: selectedCategory)
                        if let fish = selectedFish {
                            customWeight = fish.randomWeight()
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text("?")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppColors.primary)
                            
                            Text("Random")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .frame(width: 100, height: 100)
                        .background(AppColors.cardBackground)
                        .cornerRadius(Constants.UI.cornerRadius)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                    }
                }
                .padding(.horizontal, Constants.UI.screenPadding)
            }
            
            // Custom weight toggle
            if selectedFish != nil {
                HStack {
                    Text("Fish weight:")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(String(format: "%.1f lb", customWeight))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }
                .padding(.horizontal, Constants.UI.screenPadding)
            }
        }
    }
    
    // MARK: - Advanced Options
    private var advancedOptionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation {
                    showAdvancedOptions.toggle()
                }
            }) {
                HStack {
                    Text("Advanced Factors")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    ArrowRightIcon()
                        .frame(width: 16, height: 16)
                        .foregroundColor(AppColors.textSecondary)
                        .rotationEffect(.degrees(showAdvancedOptions ? 90 : 0))
                }
            }
            
            if showAdvancedOptions {
                VStack(spacing: 16) {
                    // Knot type
                    factorPicker(
                        title: "Knot Type",
                        options: KnotType.allCases.map { $0.name },
                        selected: selectedKnot.name,
                        onSelect: { name in
                            selectedKnot = KnotType.allCases.first { $0.name == name } ?? .none
                        }
                    )
                    
                    // Line wear
                    factorPicker(
                        title: "Line Condition",
                        options: LineWear.allCases.map { $0.name },
                        selected: selectedWear.name,
                        onSelect: { name in
                            selectedWear = LineWear.allCases.first { $0.name == name } ?? .new
                        }
                    )
                    
                    // Fight intensity
                    factorPicker(
                        title: "Fish Behaviour",
                        options: FightIntensity.allCases.map { $0.name },
                        selected: selectedFightIntensity.name,
                        onSelect: { name in
                            selectedFightIntensity = FightIntensity.allCases.first { $0.name == name } ?? .calm
                        }
                    )
                    
                    // Cold water toggle
                    HStack {
                        Text("Cold Water")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                        
                        Toggle("", isOn: $coldWater)
                            .labelsHidden()
                            .tint(AppColors.primary)
                    }
                }
            }
        }
        .padding(Constants.UI.cardPadding)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
        .padding(.horizontal, Constants.UI.screenPadding)
    }
    
    private func factorPicker(title: String, options: [String], selected: String, onSelect: @escaping (String) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(AppColors.textSecondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        ChipButton(
                            title: option,
                            isSelected: selected == option,
                            action: { onSelect(option) }
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Result Overlay
    private func resultOverlay(result: SimulationResult) -> some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // Dismiss on tap
                }
            
            VStack(spacing: 20) {
                // Icon
                if result.success {
                    CheckmarkIcon()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                } else {
                    CrossIcon()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                }
                
                // Title
                Text(result.success ? "FISH CAUGHT!" : "LINE BROKE!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                // Details
                VStack(spacing: 8) {
                    resultRow("Fish:", "\(result.fishName)")
                    resultRow("Weight:", String(format: "%.1f lb", result.fishWeight))
                    resultRow("Line Strength:", result.line.formattedStrengthLb)
                    resultRow("Load:", result.formattedLoadPercentage)
                    
                    if result.success {
                        resultRow("Safety Margin:", String(format: "%.0f%%", result.safetyMargin * 100))
                    } else {
                        resultRow("Overload:", String(format: "%.0f%%", result.overloadAmount * 100))
                    }
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                
                // Factors summary
                if result.factors.factorsSummary != "No modifiers" {
                    Text(result.factors.factorsSummary)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                // Buttons
                HStack(spacing: 16) {
                    PrimaryButton(title: "Try Again", action: {
                        resetSimulation()
                    }, style: .secondary)
                    
                    PrimaryButton(title: "Done", action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(result.success ? AppColors.success : AppColors.danger)
            )
            .padding(.horizontal, 20)
        }
    }
    
    private func resultRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Actions
    private func startSimulation() {
        guard let fish = selectedFish else { return }
        
        isSimulating = true
        simulationProgress = 0
        currentResult = nil
        showResult = false
        
        SoundManager.shared.playTension()
        
        // Animate the simulation
        let duration = Constants.UI.simulationDuration
        let steps = 60
        let stepDuration = duration / Double(steps)
        
        // Run simulation
        let result = SimulationEngine.simulate(
            line: line,
            fish: fish,
            fishWeight: customWeight,
            factors: currentFactors
        )
        
        // Animate progress
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(i)) {
                let progress = Double(i) / Double(steps)
                simulationProgress = result.loadPercentage * progress
                
                if i == steps {
                    finishSimulation(result: result)
                }
            }
        }
    }
    
    private func finishSimulation(result: SimulationResult) {
        currentResult = result
        isSimulating = false
        
        // Play sound
        if result.success {
            SoundManager.shared.playCatch()
        } else {
            SoundManager.shared.playBreak()
        }
        
        // Save to history
        dataManager.addTestResult(result)
        
        // Show result after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showResult = true
            }
        }
    }
    
    private func resetSimulation() {
        showResult = false
        currentResult = nil
        simulationProgress = 0
        
        if let fish = selectedFish {
            customWeight = fish.randomWeight()
        }
    }
}

// MARK: - Fish Card
struct FishCard: View {
    let fish: Fish
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                FishIcon()
                    .frame(width: 40, height: 40)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                
                Text(fish.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)
                
                Text(fish.weightRangeLb)
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(width: 100, height: 100)
            .background(AppColors.cardBackground)
            .cornerRadius(Constants.UI.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
        }
    }
}

// MARK: - Tension Gauge
struct TensionGauge: View {
    let percentage: Double
    
    private var gaugeColor: Color {
        switch percentage {
        case ..<0.7: return AppColors.gaugeSafe
        case ..<0.9: return AppColors.gaugeWarning
        case ..<1.0: return AppColors.gaugeDanger
        default: return AppColors.gaugeCritical
        }
    }
    
    var body: some View {
        ZStack {
            // Background arc
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 8)
            
            // Progress arc
            Circle()
                .trim(from: 0, to: min(percentage, 1.0))
                .stroke(gaugeColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            // Percentage text
            VStack(spacing: 2) {
                Text(String(format: "%.0f", min(percentage * 100, 999)))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text("%")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .background(
            Circle()
                .fill(Color.black.opacity(0.3))
        )
    }
}
