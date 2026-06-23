import SwiftUI

struct ErrorReportView: View {
    @Environment(\.appDependencies) private var dependencies

    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var status: String = ""

    var body: some View {
        Form {
            Section("Report") {
                TextField("Title", text: $title)
                TextField("Details", text: $detail, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
            }

            Section {
                Button("Submit") {
                    Task {
                        let ok = await dependencies.firebaseClient.submitErrorReport(payload: [
                            "title": title,
                            "detail": detail,
                            "appVersion": "v1-placeholder"
                        ])
                        status = ok ? "Report queued (placeholder)." : "Failed to queue report."
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
