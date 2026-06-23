import SwiftUI

struct SleepFragmentView: View {
    var body: some View {
        Circle()
            .fill(
                LinearGradient(colors: [.indigo, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .frame(width: 180, height: 180)
            .overlay(Circle().stroke(.white.opacity(0.3), lineWidth: 2))
            .shadow(color: .indigo.opacity(0.25), radius: 20, x: 0, y: 10)
    }
}
