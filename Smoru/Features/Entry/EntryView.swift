import SwiftUI

struct EntryView: View {
    @EnvironmentObject private var appRouter: AppRouter

    var body: some View {
        VStack(spacing: 12) {
            PlaceholderScreen(
                title: "Entry",
                subtitle: "Apple login, Google login, and trial mode buttons will be implemented by later stages."
            )
            PrimaryButton(title: "Continue to HealthKit Intro") {
                appRouter.route(to: .healthKitIntro)
            }
            .padding(.horizontal, 24)
        }
    }
}
