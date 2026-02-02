import SwiftUI

// MARK: - Calculator View
struct CalculatorView: View {
    @State private var selectedFish: Fish?
    @State private var fishBehaviour: FightIntensity = .active
    @State private var budget: BudgetTier = .midRange
    @State private var showResult = false
    
    enum BudgetTier: String, CaseIterable {
        case budget = "Budget"
        case midRange = "Mid-Range"
        case premium = "Premium"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            ScrollView {
                VStack(spacing: 20) {
                    // Fish selection
                    fishSelectionSection
                    
                    // Conditions
                    conditionsSection
                    
                    // Budget
                    budgetSection
                    
                    // Calculate button
                    PrimaryButton(
                        title: "Get Recommendation",
                        isDisabled: selectedFish == nil
                    ) {
                        showResult = true
                    }
                    .padding(.horizontal, Constants.UI.screenPadding)
                    
                    // Result
                    if showResult, let fish = selectedFish {
                        recommendationResult(for: fish)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .background(AppColors.background)
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Line Calculator")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Find the perfect line for your target")
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Fish Selection
    private var fishSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Target Fish")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, Constants.UI.screenPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(FishDatabase.allFish) { fish in
                        FishCalculatorCard(
                            fish: fish,
                            isSelected: selectedFish?.id == fish.id,
                            onTap: {
                                selectedFish = fish
                                showResult = false
                            }
                        )
                    }
                }
                .padding(.horizontal, Constants.UI.screenPadding)
            }
        }
    }
    
    // MARK: - Conditions Section
    private var conditionsSection: some View {
        TitledCard(title: "Fishing Conditions") {
            VStack(spacing: 12) {
                Text("How does the fish typically fight?")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
                
                HStack(spacing: 8) {
                    ForEach(FightIntensity.allCases, id: \.rawValue) { intensity in
                        ChipButton(
                            title: intensity.name,
                            isSelected: fishBehaviour == intensity,
                            action: {
                                fishBehaviour = intensity
                                showResult = false
                            }
                        )
                    }
                }
            }
        }
        .padding(.horizontal, Constants.UI.screenPadding)
    }
    
    // MARK: - Budget Section
    private var budgetSection: some View {
        TitledCard(title: "Budget") {
            HStack(spacing: 8) {
                ForEach(BudgetTier.allCases, id: \.rawValue) { tier in
                    ChipButton(
                        title: tier.rawValue,
                        isSelected: budget == tier,
                        action: {
                            budget = tier
                            showResult = false
                        }
                    )
                }
            }
        }
        .padding(.horizontal, Constants.UI.screenPadding)
    }
    
    // MARK: - Recommendation Result
    private func recommendationResult(for fish: Fish) -> some View {
        let recommendations = calculateRecommendations(for: fish)
        
        return VStack(spacing: 16) {
            Text("Recommended Lines")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            ForEach(recommendations.indices, id: \.self) { index in
                let rec = recommendations[index]
                RecommendationCard(
                    rank: index + 1,
                    lineType: rec.lineType,
                    diameter: rec.diameter,
                    strength: rec.strength,
                    safetyMargin: rec.safetyMargin,
                    matchesBudget: rec.matchesBudget
                )
            }
        }
        .padding(.horizontal, Constants.UI.screenPadding)
        .padding(.top, 10)
    }
    
    // MARK: - Calculation
    private func calculateRecommendations(for fish: Fish) -> [LineRecommendation] {
        var recommendations: [LineRecommendation] = []
        
        let effectiveWeight = fish.maxWeightLb * fishBehaviour.loadMultiplier
        let requiredStrength = effectiveWeight * 1.3 // 30% safety margin
        
        for lineType in LineType.allCases {
            // Find optimal diameter
            var diameter = Constants.Line.minDiameter
            var strength = 0.0
            
            while diameter <= Constants.Line.maxDiameter {
                strength = FishingLine.calculateStrength(type: lineType, diameter: diameter)
                if strength >= requiredStrength {
                    break
                }
                diameter += 0.02
            }
            
            // Check if matches budget
            let matchesBudget: Bool
            switch budget {
            case .budget:
                matchesBudget = lineType.priceTier == .budget
            case .midRange:
                matchesBudget = lineType.priceTier == .budget || lineType.priceTier == .midRange
            case .premium:
                matchesBudget = true
            }
            
            let safetyMargin = (strength - effectiveWeight) / effectiveWeight
            
            recommendations.append(LineRecommendation(
                lineType: lineType,
                diameter: diameter,
                strength: strength,
                safetyMargin: safetyMargin,
                matchesBudget: matchesBudget
            ))
        }
        
        // Sort by budget match, then by safety margin
        return recommendations.sorted {
            if $0.matchesBudget != $1.matchesBudget {
                return $0.matchesBudget
            }
            return $0.safetyMargin < $1.safetyMargin
        }
    }
}

// MARK: - Line Recommendation
struct LineRecommendation {
    let lineType: LineType
    let diameter: Double
    let strength: Double
    let safetyMargin: Double
    let matchesBudget: Bool
}

// MARK: - Fish Calculator Card
struct FishCalculatorCard: View {
    let fish: Fish
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                FishIcon()
                    .frame(width: 32, height: 32)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                
                Text(fish.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)
                
                Text(fish.weightRangeLb)
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(width: 80, height: 80)
            .background(AppColors.cardBackground)
            .cornerRadius(Constants.UI.smallCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.UI.smallCornerRadius)
                    .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Recommendation Card
struct RecommendationCard: View {
    let rank: Int
    let lineType: LineType
    let diameter: Double
    let strength: Double
    let safetyMargin: Double
    let matchesBudget: Bool
    
    private var lineColor: Color {
        switch lineType {
        case .monofilament: return AppColors.monofilament
        case .braided: return AppColors.braided
        case .fluorocarbon: return AppColors.fluorocarbon
        case .hybrid: return AppColors.hybrid
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank
            Text("#\(rank)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(rank == 1 ? AppColors.primary : AppColors.textSecondary)
                .frame(width: 32)
            
            // Line icon
            LineIcon(lineType: lineType)
                .frame(width: 32, height: 32)
            
            // Info
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(lineType.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    if matchesBudget {
                        Text("Fits Budget")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(AppColors.success)
                            .cornerRadius(8)
                    }
                }
                
                Text(String(format: "%.2fmm • %.0f lb", diameter, strength))
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            // Safety margin
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "+%.0f%%", safetyMargin * 100))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.success)
                
                Text("margin")
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(Constants.UI.cardPadding)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(rank == 1 ? lineColor.opacity(0.5) : Color.clear, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
}
