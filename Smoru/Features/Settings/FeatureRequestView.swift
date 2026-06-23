import SwiftUI

struct FeatureRequestView: View {
    @Environment(\.appDependencies) private var dependencies

    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var status: String = ""

    var body: some View {
        Form {
            Section("Feature Request") {
                TextField("Title", text: $title)
                TextField("Details", text: $detail, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
            }

            Section {
                Button("Submit") {
                    Task {
                        let ok = await dependencies.firebaseClient.submitFeatureRequest(payload: [
                            "title": title,
                            "detail": detail
                        ])
                        status = ok ? "Feature request queued (placeholder)." : "Failed to queue request."
                    }
                }
                .disabled(title.isEmpty || detail.isEmpty)

                if !status.isEmpty {
                    Text(status)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
