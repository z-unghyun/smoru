import SwiftUI

struct SleepFragmentView: View {
    let parameters: SleepFragmentParameters
    var baseSize: CGFloat = 210

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(minimumInterval: reduceMotion ? 0.8 : 1 / 30, paused: false)) { timeline in
            let phase = reduceMotion ? 0.0 : timeline.date.timeIntervalSinceReferenceDate
            let size = CGFloat(parameters.durationRatio) * baseSize

            ZStack {
                SleepFragmentBlobShape(parameters: parameters, phase: phase)
                    .fill(fragmentGradient)
                    .overlay(
                        SleepFragmentBlobShape(parameters: parameters, phase: phase)
                            .stroke(Color.white.opacity(0.18 + parameters.sharpness * 0.22), lineWidth: 1.4)
                    )
                    .overlay(innerGlow)
                    .opacity(parameters.opacity)
                    .shadow(color: .black.opacity((1 - parameters.sharpness) * 0.18), radius: 14, x: 0, y: 8)
                    .shadow(color: glowColor.opacity(parameters.innerGlow * 0.45), radius: 28, x: 0, y: 0)
                    .blur(radius: (1 - parameters.sharpness) * 1.4)
                    .frame(width: size, height: size)
                    .scaleEffect(1 + (reduceMotion ? 0 : 0.015 * sin(phase * 0.8)))
            }
            .drawingGroup()
        }
        .frame(width: baseSize * 1.28, height: baseSize * 1.28)
    }

    private var fragmentGradient: LinearGradient {
        let t = parameters.colorProgress
        let primary = Color(hue: 0.57 - (0.15 * t), saturation: 0.45 + (0.22 * t), brightness: 0.9)
        let secondary = Color(hue: 0.68 - (0.26 * t), saturation: 0.3 + (0.33 * t), brightness: 0.92)
        let tertiary = Color(hue: 0.82 - (0.2 * t), saturation: 0.2 + (0.24 * t), brightness: 0.94)

        return LinearGradient(colors: [primary, secondary, tertiary], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private var glowColor: Color {
        let t = parameters.colorProgress
        return Color(hue: 0.62 - (t * 0.2), saturation: 0.5, brightness: 0.98)
    }

    private var innerGlow: some View {
        Circle()
            .fill(glowColor.opacity(0.16 + (parameters.innerGlow * 0.35)))
            .blur(radius: 16)
            .padding(26)
    }
}

private struct SleepFragmentBlobShape: Shape {
    let parameters: SleepFragmentParameters
    let phase: TimeInterval

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let pointCount = 72

        let vibration = parameters.surfaceVibration * 0.05
        let wave = 0.022 * sin(phase * 4.5)
        let motionScale = 1.0 + vibration * wave

        var points: [CGPoint] = []
        points.reserveCapacity(pointCount)

        for index in 0..<pointCount {
            let progress = Double(index) / Double(pointCount)
            let angle = progress * .pi * 2
            let random = pseudoRandom(index: index, seed: parameters.seed)
            let roughness = (random - 0.5) * parameters.edgeRoughness * 0.45

            let axisBias = 1.0 + ((parameters.symmetry - 0.5) * 0.28 * cos(angle))
            let softnessBias = 1.0 - ((1 - parameters.roundness) * 0.28 * sin(angle * 2))

            let radial = radius * axisBias * softnessBias * (1 + roughness) * motionScale

            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radial,
                y: center.y + CGFloat(sin(angle)) * radial
            )
            points.append(point)
        }

        var path = Path()
        guard let first = points.first else { return path }

        path.move(to: first)
        for index in 0..<points.count {
            let current = points[index]
            let next = points[(index + 1) % points.count]
            let mid = CGPoint(x: (current.x + next.x) / 2, y: (current.y + next.y) / 2)
            path.addQuadCurve(to: mid, control: current)
        }
        path.closeSubpath()

        return path
    }

    private func pseudoRandom(index: Int, seed: Int) -> Double {
        let value = sin(Double(seed + index * 31) * 12.9898) * 43758.5453
        return value - floor(value)
    }
}
