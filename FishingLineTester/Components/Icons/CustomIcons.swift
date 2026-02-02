import SwiftUI

// MARK: - Custom Icons (Vector-based, no SF Symbols)
struct CustomIcons {
    
    // MARK: - Tab Bar Icons
    struct TabIcons {
        static func test(selected: Bool) -> some View {
            TestIcon().foregroundColor(selected ? AppColors.primary : AppColors.textSecondary)
        }
        
        static func knowledge(selected: Bool) -> some View {
            BookIcon().foregroundColor(selected ? AppColors.primary : AppColors.textSecondary)
        }
        
        static func calculator(selected: Bool) -> some View {
            CalculatorIcon().foregroundColor(selected ? AppColors.primary : AppColors.textSecondary)
        }
        
        static func history(selected: Bool) -> some View {
            HistoryIcon().foregroundColor(selected ? AppColors.primary : AppColors.textSecondary)
        }
        
        static func achievements(selected: Bool) -> some View {
            TrophyIcon().foregroundColor(selected ? AppColors.primary : AppColors.textSecondary)
        }
    }
}

// MARK: - Test/Fishing Rod Icon
struct TestIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                // Rod
                path.move(to: CGPoint(x: size * 0.1, y: size * 0.9))
                path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.2))
                
                // Line
                path.move(to: CGPoint(x: size * 0.8, y: size * 0.2))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.9, y: size * 0.8),
                    control: CGPoint(x: size * 0.95, y: size * 0.4)
                )
                
                // Hook
                path.move(to: CGPoint(x: size * 0.9, y: size * 0.8))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.75, y: size * 0.85),
                    control: CGPoint(x: size * 0.85, y: size * 0.9)
                )
            }
            .stroke(style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round, lineJoin: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Book Icon
struct BookIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                // Book spine
                path.move(to: CGPoint(x: size * 0.5, y: size * 0.15))
                path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.85))
                
                // Left page
                path.move(to: CGPoint(x: size * 0.15, y: size * 0.2))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: size * 0.15),
                    control: CGPoint(x: size * 0.3, y: size * 0.1)
                )
                path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.85))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.15, y: size * 0.8),
                    control: CGPoint(x: size * 0.3, y: size * 0.9)
                )
                path.closeSubpath()
                
                // Right page
                path.move(to: CGPoint(x: size * 0.85, y: size * 0.2))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: size * 0.15),
                    control: CGPoint(x: size * 0.7, y: size * 0.1)
                )
                path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.85))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.85, y: size * 0.8),
                    control: CGPoint(x: size * 0.7, y: size * 0.9)
                )
                path.closeSubpath()
            }
            .stroke(style: StrokeStyle(lineWidth: size * 0.06, lineCap: .round, lineJoin: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Calculator Icon
struct CalculatorIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            ZStack {
                // Border
                RoundedRectangle(cornerRadius: size * 0.15)
                    .stroke(lineWidth: size * 0.06)
                    .frame(width: size * 0.8, height: size * 0.9)
                
                // Display area
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: size * 0.6, height: size * 0.2)
                    .overlay(
                        Rectangle()
                            .stroke(lineWidth: size * 0.04)
                    )
                    .offset(y: -size * 0.2)
                
                // Buttons (3x2 grid)
                VStack(spacing: size * 0.08) {
                    HStack(spacing: size * 0.08) {
                        Circle().frame(width: size * 0.12)
                        Circle().frame(width: size * 0.12)
                        Circle().frame(width: size * 0.12)
                    }
                    HStack(spacing: size * 0.08) {
                        Circle().frame(width: size * 0.12)
                        Circle().frame(width: size * 0.12)
                        Circle().frame(width: size * 0.12)
                    }
                }
                .offset(y: size * 0.18)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - History/Clock Icon
struct HistoryIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            ZStack {
                // Circle
                Circle()
                    .stroke(lineWidth: size * 0.08)
                
                // Clock hands
                Path { path in
                    let center = CGPoint(x: size * 0.5, y: size * 0.5)
                    // Hour hand
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.3))
                    // Minute hand
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: size * 0.7, y: size * 0.5))
                }
                .stroke(style: StrokeStyle(lineWidth: size * 0.06, lineCap: .round))
                
                // Arrow indicating history
                Path { path in
                    path.move(to: CGPoint(x: size * 0.15, y: size * 0.35))
                    path.addLine(to: CGPoint(x: size * 0.25, y: size * 0.15))
                    path.addLine(to: CGPoint(x: size * 0.35, y: size * 0.35))
                }
                .stroke(style: StrokeStyle(lineWidth: size * 0.05, lineCap: .round, lineJoin: .round))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Trophy Icon
struct TrophyIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                // Cup body
                path.move(to: CGPoint(x: size * 0.2, y: size * 0.15))
                path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.55))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.7, y: size * 0.55),
                    control: CGPoint(x: size * 0.5, y: size * 0.7)
                )
                path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.15))
                
                // Left handle
                path.move(to: CGPoint(x: size * 0.2, y: size * 0.2))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.2, y: size * 0.45),
                    control: CGPoint(x: size * 0.05, y: size * 0.32)
                )
                
                // Right handle
                path.move(to: CGPoint(x: size * 0.8, y: size * 0.2))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.8, y: size * 0.45),
                    control: CGPoint(x: size * 0.95, y: size * 0.32)
                )
                
                // Stem
                path.move(to: CGPoint(x: size * 0.5, y: size * 0.6))
                path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.75))
                
                // Base
                path.move(to: CGPoint(x: size * 0.3, y: size * 0.85))
                path.addLine(to: CGPoint(x: size * 0.7, y: size * 0.85))
                path.move(to: CGPoint(x: size * 0.35, y: size * 0.75))
                path.addLine(to: CGPoint(x: size * 0.65, y: size * 0.75))
            }
            .stroke(style: StrokeStyle(lineWidth: size * 0.06, lineCap: .round, lineJoin: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Fish Icon
struct FishIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                // Body
                path.move(to: CGPoint(x: size * 0.15, y: size * 0.5))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.7, y: size * 0.5),
                    control: CGPoint(x: size * 0.4, y: size * 0.15)
                )
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.15, y: size * 0.5),
                    control: CGPoint(x: size * 0.4, y: size * 0.85)
                )
                
                // Tail
                path.move(to: CGPoint(x: size * 0.15, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.0, y: size * 0.3))
                path.move(to: CGPoint(x: size * 0.15, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.0, y: size * 0.7))
                
                // Eye
                path.addEllipse(in: CGRect(x: size * 0.55, y: size * 0.4, width: size * 0.1, height: size * 0.1))
                
                // Fin
                path.move(to: CGPoint(x: size * 0.4, y: size * 0.35))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: size * 0.35),
                    control: CGPoint(x: size * 0.45, y: size * 0.15)
                )
            }
            .stroke(style: StrokeStyle(lineWidth: size * 0.06, lineCap: .round, lineJoin: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Line Icon
struct LineIcon: View {
    var lineType: LineType
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            switch lineType {
            case .monofilament:
                // Single wavy line
                Path { path in
                    path.move(to: CGPoint(x: size * 0.1, y: size * 0.5))
                    path.addCurve(
                        to: CGPoint(x: size * 0.9, y: size * 0.5),
                        control1: CGPoint(x: size * 0.35, y: size * 0.2),
                        control2: CGPoint(x: size * 0.65, y: size * 0.8)
                    )
                }
                .stroke(style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round))
                .foregroundColor(AppColors.monofilament)
                
            case .braided:
                // Braided pattern
                ZStack {
                    ForEach(0..<3, id: \.self) { i in
                        Path { path in
                            let yOffset = CGFloat(i - 1) * size * 0.15
                            path.move(to: CGPoint(x: size * 0.1, y: size * 0.5 + yOffset))
                            path.addCurve(
                                to: CGPoint(x: size * 0.9, y: size * 0.5 - yOffset),
                                control1: CGPoint(x: size * 0.4, y: size * 0.3 + yOffset),
                                control2: CGPoint(x: size * 0.6, y: size * 0.7 - yOffset)
                            )
                        }
                        .stroke(style: StrokeStyle(lineWidth: size * 0.04, lineCap: .round))
                        .foregroundColor(AppColors.braided)
                    }
                }
                
            case .fluorocarbon:
                // Crystal-like line
                Path { path in
                    path.move(to: CGPoint(x: size * 0.1, y: size * 0.5))
                    path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.4))
                    path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.55))
                    path.addLine(to: CGPoint(x: size * 0.7, y: size * 0.45))
                    path.addLine(to: CGPoint(x: size * 0.9, y: size * 0.5))
                }
                .stroke(style: StrokeStyle(lineWidth: size * 0.06, lineCap: .round, lineJoin: .round))
                .foregroundColor(AppColors.fluorocarbon)
                
            case .hybrid:
                // Mixed pattern
                ZStack {
                    Path { path in
                        path.move(to: CGPoint(x: size * 0.1, y: size * 0.5))
                        path.addCurve(
                            to: CGPoint(x: size * 0.9, y: size * 0.5),
                            control1: CGPoint(x: size * 0.35, y: size * 0.25),
                            control2: CGPoint(x: size * 0.65, y: size * 0.75)
                        )
                    }
                    .stroke(style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round))
                    .foregroundColor(AppColors.hybrid.opacity(0.5))
                    
                    Path { path in
                        path.move(to: CGPoint(x: size * 0.1, y: size * 0.5))
                        path.addCurve(
                            to: CGPoint(x: size * 0.9, y: size * 0.5),
                            control1: CGPoint(x: size * 0.35, y: size * 0.25),
                            control2: CGPoint(x: size * 0.65, y: size * 0.75)
                        )
                    }
                    .stroke(style: StrokeStyle(lineWidth: size * 0.04, lineCap: .round))
                    .foregroundColor(AppColors.hybrid)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Checkmark Icon
struct CheckmarkIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                path.move(to: CGPoint(x: size * 0.2, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.4, y: size * 0.75))
                path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.25))
            }
            .stroke(style: StrokeStyle(lineWidth: size * 0.12, lineCap: .round, lineJoin: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Cross Icon
struct CrossIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                path.move(to: CGPoint(x: size * 0.2, y: size * 0.2))
                path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.8))
                path.move(to: CGPoint(x: size * 0.8, y: size * 0.2))
                path.addLine(to: CGPoint(x: size * 0.2, y: size * 0.8))
            }
            .stroke(style: StrokeStyle(lineWidth: size * 0.12, lineCap: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Warning Icon
struct WarningIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: size * 0.5, y: size * 0.1))
                    path.addLine(to: CGPoint(x: size * 0.9, y: size * 0.85))
                    path.addLine(to: CGPoint(x: size * 0.1, y: size * 0.85))
                    path.closeSubpath()
                }
                .stroke(style: StrokeStyle(lineWidth: size * 0.06, lineCap: .round, lineJoin: .round))
                
                // Exclamation
                Path { path in
                    path.move(to: CGPoint(x: size * 0.5, y: size * 0.35))
                    path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.55))
                }
                .stroke(style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round))
                
                Circle()
                    .fill()
                    .frame(width: size * 0.08, height: size * 0.08)
                    .position(x: size * 0.5, y: size * 0.7)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Settings Icon
struct SettingsIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            ZStack {
                Circle()
                    .stroke(lineWidth: size * 0.08)
                    .frame(width: size * 0.4, height: size * 0.4)
                
                ForEach(0..<8, id: \.self) { i in
                    Path { path in
                        let angle = Double(i) * .pi / 4
                        let innerRadius = size * 0.28
                        let outerRadius = size * 0.45
                        let center = CGPoint(x: size * 0.5, y: size * 0.5)
                        
                        path.move(to: CGPoint(
                            x: center.x + CGFloat(cos(angle)) * innerRadius,
                            y: center.y + CGFloat(sin(angle)) * innerRadius
                        ))
                        path.addLine(to: CGPoint(
                            x: center.x + CGFloat(cos(angle)) * outerRadius,
                            y: center.y + CGFloat(sin(angle)) * outerRadius
                        ))
                    }
                    .stroke(style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Plus Icon
struct PlusIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                path.move(to: CGPoint(x: size * 0.5, y: size * 0.15))
                path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.85))
                path.move(to: CGPoint(x: size * 0.15, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.85, y: size * 0.5))
            }
            .stroke(style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Arrow Icons
struct ArrowRightIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                path.move(to: CGPoint(x: size * 0.3, y: size * 0.2))
                path.addLine(to: CGPoint(x: size * 0.7, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.8))
            }
            .stroke(style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct ArrowLeftIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                path.move(to: CGPoint(x: size * 0.7, y: size * 0.2))
                path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.7, y: size * 0.8))
            }
            .stroke(style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
