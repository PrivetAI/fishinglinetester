import SwiftUI

// MARK: - Fishing Line Animation
struct LineAnimationView: View {
    let loadPercentage: Double
    let isAnimating: Bool
    let isBroken: Bool
    
    @State private var tension: CGFloat = 0
    @State private var breakOffset: CGFloat = 0
    @State private var shakeFactor: CGFloat = 0
    
    var lineColor: Color {
        switch loadPercentage {
        case ..<0.7: return AppColors.gaugeSafe
        case ..<0.9: return AppColors.gaugeWarning
        case ..<1.0: return AppColors.gaugeDanger
        default: return AppColors.gaugeCritical
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            if isBroken {
                // Broken line animation
                ZStack {
                    // Top part
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.5, y: 0))
                        path.addQuadCurve(
                            to: CGPoint(x: size.width * 0.5 - breakOffset, y: size.height * 0.4),
                            control: CGPoint(x: size.width * 0.4, y: size.height * 0.2)
                        )
                    }
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    
                    // Bottom part
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.5 + breakOffset, y: size.height * 0.45))
                        path.addQuadCurve(
                            to: CGPoint(x: size.width * 0.5, y: size.height * 0.9),
                            control: CGPoint(x: size.width * 0.6, y: size.height * 0.7)
                        )
                    }
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    
                    // Break spark
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                        .position(x: size.width * 0.5, y: size.height * 0.42)
                        .opacity(breakOffset > 0 ? 1 : 0)
                        .scaleEffect(breakOffset > 0 ? 2 : 0)
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 0.3)) {
                        breakOffset = 30
                    }
                }
            } else {
                // Normal tension line
                Path { path in
                    let curveAmount = tension * size.width * 0.15
                    let shakeX = shakeFactor * 3
                    
                    path.move(to: CGPoint(x: size.width * 0.5 + shakeX, y: 0))
                    path.addQuadCurve(
                        to: CGPoint(x: size.width * 0.5 + shakeX, y: size.height * 0.9),
                        control: CGPoint(x: size.width * 0.5 + curveAmount + shakeX, y: size.height * 0.5)
                    )
                }
                .stroke(
                    lineColor,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .onChange(of: isAnimating) { animating in
                    if animating {
                        animateTension()
                    } else {
                        tension = 0
                        shakeFactor = 0
                    }
                }
                .onChange(of: loadPercentage) { newLoad in
                    if newLoad > 0.8 {
                        startShaking()
                    }
                }
            }
        }
    }
    
    private func animateTension() {
        withAnimation(.easeInOut(duration: Constants.UI.simulationDuration)) {
            tension = CGFloat(loadPercentage)
        }
    }
    
    private func startShaking() {
        withAnimation(.linear(duration: 0.05).repeatForever(autoreverses: true)) {
            shakeFactor = 1
        }
    }
}

// MARK: - Rod Animation View
struct RodAnimationView: View {
    let loadPercentage: Double
    let isAnimating: Bool
    
    @State private var bendAngle: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            Path { path in
                // Rod base
                path.move(to: CGPoint(x: size.width * 0.1, y: size.height * 0.9))
                
                // Bent rod curve
                let control1 = CGPoint(
                    x: size.width * 0.3,
                    y: size.height * (0.6 - bendAngle * 0.2)
                )
                let control2 = CGPoint(
                    x: size.width * 0.6,
                    y: size.height * (0.3 - bendAngle * 0.15)
                )
                let end = CGPoint(
                    x: size.width * 0.85,
                    y: size.height * (0.15 + bendAngle * 0.1)
                )
                
                path.addCurve(to: end, control1: control1, control2: control2)
            }
            .stroke(
                LinearGradient(
                    colors: [Color(hex: "8B4513"), Color(hex: "D2691E")],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 6, lineCap: .round)
            )
            
            // Handle
            Ellipse()
                .fill(Color(hex: "654321"))
                .frame(width: 25, height: 40)
                .position(x: size.width * 0.08, y: size.height * 0.92)
        }
        .onChange(of: isAnimating) { animating in
            if animating {
                animateBend()
            } else {
                withAnimation(.easeOut(duration: 0.3)) {
                    bendAngle = 0
                }
            }
        }
    }
    
    private func animateBend() {
        withAnimation(.easeInOut(duration: Constants.UI.simulationDuration)) {
            bendAngle = min(loadPercentage, 1.0)
        }
    }
}

// MARK: - Hook Icon
struct HookIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                path.move(to: CGPoint(x: size * 0.5, y: size * 0.1))
                path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.5))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.3, y: size * 0.7),
                    control: CGPoint(x: size * 0.5, y: size * 0.7)
                )
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: size * 0.9),
                    control: CGPoint(x: size * 0.2, y: size * 0.85)
                )
                path.addLine(to: CGPoint(x: size * 0.6, y: size * 0.75))
            }
            .stroke(Color.gray, style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round, lineJoin: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
