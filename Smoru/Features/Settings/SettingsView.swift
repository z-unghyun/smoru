import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appRouter: AppRouter

    var body: some View {
        List {
            Section("Data and Privacy") {
                Button("Privacy and Data") {
                    appRouter.route(to: .privacyData)
                }
            }

            Section("Feedback") {
                Button("Error Report") {
                    appRouter.route(to: .errorReport)
                }
                Button("Feature Request") {
                    appRouter.route(to: .featureRequest)
                }
            }

            Section("Navigation") {
                Button("Back Home") {
                    appRouter.route(to: .home)
                }
            }
        }
    }
}
