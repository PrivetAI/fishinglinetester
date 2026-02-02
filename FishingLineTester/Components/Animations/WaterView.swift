import SwiftUI

// MARK: - Water View with Waves
struct WaterView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                AppGradients.water
                
                // Wave layers
                WaveShape(phase: phase, amplitude: 8, frequency: 1.5)
                    .fill(AppColors.waterLight.opacity(0.3))
                    .offset(y: geometry.size.height * 0.02)
                
                WaveShape(phase: phase + 0.5, amplitude: 6, frequency: 2)
                    .fill(AppColors.waterSurface.opacity(0.4))
                    .offset(y: geometry.size.height * 0.01)
                
                WaveShape(phase: phase + 1, amplitude: 4, frequency: 2.5)
                    .fill(AppColors.waterSurface.opacity(0.5))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

// MARK: - Wave Shape
struct WaveShape: Shape {
    var phase: CGFloat
    var amplitude: CGFloat
    var frequency: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.height * 0.1
        
        path.move(to: CGPoint(x: 0, y: midY))
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / rect.width
            let sine = sin(relativeX * frequency * .pi * 2 + phase)
            let y = midY + sine * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Bubble View
struct BubbleView: View {
    @State private var bubbles: [Bubble] = []
    let bubbleCount = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(Color.white.opacity(bubble.opacity))
                        .frame(width: bubble.size, height: bubble.size)
                        .position(bubble.position)
                }
            }
            .onAppear {
                createBubbles(in: geometry.size)
                animateBubbles(in: geometry.size)
            }
        }
    }
    
    private func createBubbles(in size: CGSize) {
        bubbles = (0..<bubbleCount).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: size.height * 0.5...size.height)
                ),
                size: CGFloat.random(in: 3...10),
                opacity: Double.random(in: 0.2...0.6)
            )
        }
    }
    
    private func animateBubbles(in size: CGSize) {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            for i in bubbles.indices {
                bubbles[i].position.y -= bubbles[i].speed
                bubbles[i].position.x += CGFloat.random(in: -0.5...0.5)
                
                if bubbles[i].position.y < 0 {
                    bubbles[i].position.y = size.height
                    bubbles[i].position.x = CGFloat.random(in: 0...size.width)
                }
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let speed: CGFloat = CGFloat.random(in: 0.5...1.5)
}

// MARK: - Ripple Effect
struct RippleEffect: View {
    @State private var animate = false
    let color: Color
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(color.opacity(animate ? 0 : 0.5), lineWidth: 2)
                    .scaleEffect(animate ? 3 : 0.5)
                    .animation(
                        Animation.easeOut(duration: 2)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.6),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
