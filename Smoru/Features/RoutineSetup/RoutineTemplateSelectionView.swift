import SwiftUI
import SwiftData

struct RoutineTemplateSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appRouter: AppRouter

    @Query(sort: [SortDescriptor(\RoutineTemplateModel.createdAt, order: .forward)])
    private var templates: [RoutineTemplateModel]

    var body: some View {
        List {
            Section("Choose a Routine Template") {
                ForEach(templates) { template in
                    Button {
                        appState.selectedRoutineTemplateID = template.id
                        appRouter.route(to: .routineSetup)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(template.name)
                                .font(.headline)
                            Text("End time: \(template.routineEndHour):\(String(format: "%02d", template.routineEndMinute))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Routine Templates")
        .onAppear {
            if templates.isEmpty {
                seedTemplatesIfNeeded()
            }
        }
    }

    private func seedTemplatesIfNeeded() {
        guard templates.isEmpty else { return }
        for template in DomainSampleData.sampleRoutineTemplates() {
            modelContext.insert(template)
        }
        try? modelContext.save()
    }
}
