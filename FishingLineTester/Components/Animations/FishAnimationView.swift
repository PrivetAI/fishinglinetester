import SwiftUI

// MARK: - Fish Animation View
struct FishAnimationView: View {
    let fishName: String
    let isAnimating: Bool
    let isCaught: Bool
    let isEscaping: Bool
    
    @State private var fishY: CGFloat = 0.7
    @State private var fishRotation: Double = 0
    @State private var fishScale: CGFloat = 1.0
    @State private var wiggle: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack {
                // Fish body
                FishShape()
                    .fill(fishGradient)
                    .frame(width: size.width * 0.3, height: size.width * 0.15)
                    .scaleEffect(fishScale)
                    .rotationEffect(.degrees(fishRotation + Double(wiggle * 5)))
                    .position(
                        x: size.width * 0.5 + wiggle * 10,
                        y: size.height * fishY
                    )
                
                // Splash effect when caught
                if isCaught {
                    SplashEffect()
                        .position(x: size.width * 0.5, y: size.height * 0.3)
                }
            }
        }
        .onChange(of: isAnimating) { animating in
            if animating {
                startWiggle()
            } else {
                wiggle = 0
            }
        }
        .onChange(of: isCaught) { caught in
            if caught {
                animateCatch()
            }
        }
        .onChange(of: isEscaping) { escaping in
            if escaping {
                animateEscape()
            }
        }
    }
    
    private var fishGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "4A90A4"),
                Color(hex: "2E5A6B"),
                Color(hex: "1A3A44")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private func startWiggle() {
        withAnimation(.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) {
            wiggle = 1
        }
    }
    
    private func animateCatch() {
        withAnimation(.easeOut(duration: 0.8)) {
            fishY = 0.2
            fishRotation = -15
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.4)) {
                fishScale = 1.2
            }
        }
    }
    
    private func animateEscape() {
        withAnimation(.easeIn(duration: 0.5)) {
            fishY = 1.2
            fishRotation = 30
            fishScale = 0.8
        }
    }
}

// MARK: - Fish Shape
struct FishShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.width
        let h = rect.height
        
        // Body
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.5))
        
        // Top curve
        path.addQuadCurve(
            to: CGPoint(x: w * 0.85, y: h * 0.5),
            control: CGPoint(x: w * 0.5, y: h * 0.0)
        )
        
        // Bottom curve
        path.addQuadCurve(
            to: CGPoint(x: w * 0.15, y: h * 0.5),
            control: CGPoint(x: w * 0.5, y: h * 1.0)
        )
        
        // Tail
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.0, y: h * 0.2))
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.0, y: h * 0.8))
        
        // Eye
        path.addEllipse(in: CGRect(x: w * 0.7, y: h * 0.35, width: w * 0.08, height: h * 0.2))
        
        // Fin
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.15))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.6, y: h * 0.15),
            control: CGPoint(x: w * 0.55, y: h * -0.1)
        )
        
        return path
    }
}

// MARK: - Splash Effect
struct SplashEffect: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                let angle = Double(index) * .pi / 4
                
                Circle()
                    .fill(AppColors.waterSurface)
                    .frame(width: 8, height: 8)
                    .offset(
                        x: animate ? CGFloat(cos(angle)) * 40 : 0,
                        y: animate ? CGFloat(sin(angle)) * 40 - 20 : 0
                    )
                    .opacity(animate ? 0 : 1)
            }
            
            // Water drops
            ForEach(0..<6, id: \.self) { index in
                Ellipse()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 6, height: 12)
                    .offset(
                        x: CGFloat.random(in: -30...30),
                        y: animate ? -60 : 0
                    )
                    .opacity(animate ? 0 : 0.8)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animate = true
            }
        }
    }
}

// MARK: - Success Overlay
struct SuccessOverlay: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            
            VStack(spacing: 20) {
                CheckmarkIcon()
                    .frame(width: 80, height: 80)
                    .foregroundColor(AppColors.success)
                
                Text("FISH CAUGHT!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.success.opacity(0.9))
            )
            .scaleEffect(scale)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1
            }
        }
    }
}

// MARK: - Failure Overlay
struct FailureOverlay: View {
    @State private var shake: CGFloat = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            
            VStack(spacing: 20) {
                CrossIcon()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                
                Text("LINE BROKE!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.danger.opacity(0.9))
            )
            .offset(x: shake)
        }
        .opacity(opacity)
        .onAppear {
            opacity = 1
            withAnimation(.linear(duration: 0.08).repeatCount(6, autoreverses: true)) {
                shake = 10
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                shake = 0
            }
        }
    }
}
