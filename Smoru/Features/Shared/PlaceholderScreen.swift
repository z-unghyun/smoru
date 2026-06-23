import SwiftUI

struct PlaceholderScreen: View {
    let title: String
    let subtitle: String

    var body: some View {
        ZStack {
            SmoruColors.background.ignoresSafeArea()
            VStack(spacing: 16) {
                Text(title)
                    .font(SmoruTypography.title)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(SmoruTypography.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
        }
    }
}
