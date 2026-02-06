import SwiftUI

// MARK: - Knowledge Base View
struct KnowledgeBaseView: View {
    @State private var selectedSection: KnowledgeSection = .lineTypes
    
    enum KnowledgeSection: String, CaseIterable {
        case lineTypes = "Line Types"
        case tables = "Tables"
        case tips = "Tips & Facts"
        case knots = "Knots"
        case quiz = "Quiz"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            // Section picker
            sectionPicker
            
            // Content
            ScrollView {
                switch selectedSection {
                case .lineTypes:
                    lineTypesSection
                case .tables:
                    tablesSection
                case .tips:
                    tipsSection
                case .knots:
                    knotsSection
                case .quiz:
                    QuizView()
                }
            }
        }
        .background(AppColors.background)
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Knowledge Base")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Learn everything about fishing lines")
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(KnowledgeSection.allCases, id: \.rawValue) { section in
                    ChipButton(
                        title: section.rawValue,
                        isSelected: selectedSection == section,
                        action: { selectedSection = section }
                    )
                }
            }
            .padding(.horizontal, Constants.UI.screenPadding)
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Line Types Section
    private var lineTypesSection: some View {
        VStack(spacing: 16) {
            ForEach(LineType.allCases) { lineType in
                LineTypeDetailCard(lineType: lineType)
            }
        }
        .padding(.horizontal, Constants.UI.screenPadding)
        .padding(.bottom, 20)
    }
    
    // MARK: - Tables Section
    private var tablesSection: some View {
        VStack(spacing: 20) {
            // Fish recommendations table
            TitledCard(title: "Recommended Line by Fish") {
                VStack(spacing: 0) {
                    tableHeader(["Fish", "Weight", "Line"])
                    
                    ForEach(FishDatabase.allFish.prefix(10)) { fish in
                        tableRow([
                            fish.name,
                            fish.weightRangeLb,
                            String(format: "%.0f+ lb", fish.recommendedLineLb)
                        ])
                    }
                }
            }
            
            // Strength by diameter table
            TitledCard(title: "Strength by Diameter") {
                VStack(spacing: 0) {
                    tableHeader(["Diameter", "Mono", "Braid", "Fluoro"])
                    
                    ForEach([0.10, 0.14, 0.18, 0.20, 0.25, 0.30], id: \.self) { diameter in
                        let mono = FishingLine.calculateStrength(type: .monofilament, diameter: diameter)
                        let braid = FishingLine.calculateStrength(type: .braided, diameter: diameter)
                        let fluoro = FishingLine.calculateStrength(type: .fluorocarbon, diameter: diameter)
                        
                        tableRow([
                            String(format: "%.2fmm", diameter),
                            String(format: "%.0f lb", mono),
                            String(format: "%.0f lb", braid),
                            String(format: "%.0f lb", fluoro)
                        ])
                    }
                }
            }
        }
        .padding(.horizontal, Constants.UI.screenPadding)
        .padding(.bottom, 20)
    }
    
    private func tableHeader(_ columns: [String]) -> some View {
        HStack(spacing: 0) {
            ForEach(columns.indices, id: \.self) { index in
                Text(columns[index])
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: index == 0 ? .leading : .trailing)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(AppColors.background)
    }
    
    private func tableRow(_ columns: [String]) -> some View {
        HStack(spacing: 0) {
            ForEach(columns.indices, id: \.self) { index in
                Text(columns[index])
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: index == 0 ? .leading : .trailing)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
    }
    
    // MARK: - Tips Section
    private var tipsSection: some View {
        VStack(spacing: 12) {
            TitledCard(title: "Interesting Facts") {
                VStack(alignment: .leading, spacing: 12) {
                    factItem("Knots reduce line strength by 5-15%")
                    factItem("Braided line is 2x stronger than mono at the same diameter")
                    factItem("Line ages even when not used")
                    factItem("Fish jerks can double the load on the line")
                    factItem("Fluorocarbon is 78% invisible in water")
                    factItem("Wet line is 10-15% stronger than dry")
                }
            }
            
            TitledCard(title: "Pro Tips") {
                VStack(alignment: .leading, spacing: 12) {
                    tipItem("Replace line every 6 months of active use", important: true)
                    tipItem("For winter fishing, choose low-memory line", important: false)
                    tipItem("Always use 30-50% safety margin over fish weight", important: true)
                    tipItem("Check your line before every fishing trip", important: false)
                    tipItem("Store line away from direct sunlight", important: false)
                }
            }
        }
        .padding(.horizontal, Constants.UI.screenPadding)
        .padding(.bottom, 20)
    }
    
    private func factItem(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(AppColors.primary)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(AppColors.textPrimary)
        }
    }
    
    private func tipItem(_ text: String, important: Bool) -> some View {
        HStack(alignment: .top, spacing: 10) {
            if important {
                WarningIcon()
                    .frame(width: 16, height: 16)
                    .foregroundColor(AppColors.warning)
            } else {
                CheckmarkIcon()
                    .frame(width: 16, height: 16)
                    .foregroundColor(AppColors.success)
            }
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(AppColors.textPrimary)
        }
    }
    
    // MARK: - Knots Section
    private var knotsSection: some View {
        VStack(spacing: 16) {
            ForEach(KnotType.allCases.filter { $0 != .none }) { knot in
                KnotCard(knot: knot)
            }
        }
        .padding(.horizontal, Constants.UI.screenPadding)
        .padding(.bottom, 20)
    }
}

// MARK: - Line Type Detail Card
struct LineTypeDetailCard: View {
    let lineType: LineType
    @State private var isExpanded = false
    
    private var lineColor: Color {
        switch lineType {
        case .monofilament: return AppColors.monofilament
        case .braided: return AppColors.braided
        case .fluorocarbon: return AppColors.fluorocarbon
        case .hybrid: return AppColors.hybrid
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    LineIcon(lineType: lineType)
                        .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(lineType.name)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(lineType.shortName)
                            .font(.system(size: 13))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    ArrowRightIcon()
                        .frame(width: 16, height: 16)
                        .foregroundColor(AppColors.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
            
            if isExpanded {
                // Description
                Text(lineType.description)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
                
                // Properties
                HStack(spacing: 16) {
                    propertyBadge("Stretch", lineType.stretch.rawValue)
                    propertyBadge("Visibility", lineType.visibility.rawValue)
                    propertyBadge("Durability", lineType.durability.rawValue)
                }
                
                // Pros
                VStack(alignment: .leading, spacing: 6) {
                    Text("Advantages")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColors.success)
                    
                    ForEach(lineType.pros, id: \.self) { pro in
                        HStack(spacing: 6) {
                            CheckmarkIcon()
                                .frame(width: 12, height: 12)
                                .foregroundColor(AppColors.success)
                            Text(pro)
                                .font(.system(size: 13))
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                }
                
                // Cons
                VStack(alignment: .leading, spacing: 6) {
                    Text("Disadvantages")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColors.danger)
                    
                    ForEach(lineType.cons, id: \.self) { con in
                        HStack(spacing: 6) {
                            CrossIcon()
                                .frame(width: 12, height: 12)
                                .foregroundColor(AppColors.danger)
                            Text(con)
                                .font(.system(size: 13))
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                }
                
                // Best for
                HStack {
                    Text("Best for:")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(lineType.bestFor)
                        .font(.system(size: 13))
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .padding(Constants.UI.cardPadding)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(lineColor.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
    
    private func propertyBadge(_ title: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(AppColors.background)
        .cornerRadius(8)
    }
}

// MARK: - Knot Card
struct KnotCard: View {
    let knot: KnotType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(knot.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text("-\(Int(knot.strengthReduction * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.warning)
            }
            
            Text(knot.description)
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(Constants.UI.cardPadding)
        .background(AppColors.cardBackground)
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
}
