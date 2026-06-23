import SwiftUI

struct EntryView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 16) {
            PlaceholderScreen(
                title: "SMORU Entry",
                subtitle: "Continue with Apple, Continue with Google, or Try without login."
            )

            PrimaryButton(title: "Continue with Apple") {
                appState.isTrialModeEnabled = false
                appRouter.route(to: .healthKitIntro)
            }
            .padding(.horizontal, 24)

            PrimaryButton(title: "Continue with Google") {
                appState.isTrialModeEnabled = false
                appRouter.route(to: .healthKitIntro)
            }
            .padding(.horizontal, 24)

            Button("Try without login") {
                appState.isTrialModeEnabled = true
                appRouter.route(to: .healthKitIntro)
            }
            .buttonStyle(.bordered)
        }
    }
}
