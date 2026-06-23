import SwiftUI

struct HealthKitIntroView: View {
    @EnvironmentObject private var appRouter: AppRouter

    var body: some View {
        VStack(spacing: 16) {
            PlaceholderScreen(
                title: "Apple Health Access",
                subtitle: "SMORU reads sleep, heart rate, HRV, respiratory rate, and activity context to generate your daily sleep fragment. You can continue with manual input if data is unavailable."
            )

            PrimaryButton(title: "Continue to Permission Request") {
                appRouter.route(to: .healthKitPermissionState)
            }
            .padding(.horizontal, 24)
        }
    }
}
