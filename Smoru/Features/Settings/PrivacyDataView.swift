import SwiftUI

struct PrivacyDataView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy and Data")
                    .font(.title3.weight(.semibold))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Stored Locally on Device")
                        .font(.headline)
                    Text("- Health source data summaries")
                    Text("- Manual condition input")
                    Text("- Routine execution and task records")
                    Text("- Sleep fragment parameters")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Remote Placeholder Scope (Firebase V1)")
                        .font(.headline)
                    Text("- User profile")
                    Text("- Routine settings backup")
                    Text("- App settings backup")
                    Text("- Error reports")
                    Text("- Feature requests")
                    Text("- Minimal event labels")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Not Uploaded in V1")
                        .font(.headline)
                    Text("- Raw HealthKit samples")
                    Text("- Routine execution records")
                    Text("- Task execution records")
                }
            }
            .padding()
        }
    }
}
