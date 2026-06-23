import SwiftUI

struct TrialHomeView: View {
    @EnvironmentObject private var appRouter: AppRouter

    var body: some View {
        let parameters = DomainSampleData.sampleFragmentParameters(for: .now)

        VStack(spacing: 20) {
            Text("Trial Mode")
                .font(SmoruTypography.title)

            SleepFragmentView(parameters: parameters)

            Text("Sample sleep fragment is generated locally for trial mode.")
                .font(SmoruTypography.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)

            PrimaryButton(title: "Open Home") {
                appRouter.route(to: .home)
            }
            .padding(.horizontal, 24)
        }
    }
}
