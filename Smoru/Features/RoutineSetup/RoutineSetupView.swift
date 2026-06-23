import SwiftUI
import SwiftData

struct RoutineSetupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appDependencies) private var dependencies
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appRouter: AppRouter

    @Query(sort: [SortDescriptor(\RoutineTemplateModel.createdAt, order: .forward)])
    private var templates: [RoutineTemplateModel]

    @State private var selectedMode: RoutineMode = .basic
    @State private var endTime: Date = .now
    @State private var notificationStatus: String = ""

    private let scheduleEngine = RoutineScheduleEngine()

    var body: some View {
        Group {
            if let template = selectedTemplate {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(template.name)
                            .font(.title3.weight(.semibold))

                        DatePicker("Routine End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                            .onChange(of: endTime) { _, value in
                                updateEndTime(value, for: template)
                            }

                        Picker("Mode", selection: $selectedMode) {
                            Text("Expanded").tag(RoutineMode.expanded)
                            Text("Basic").tag(RoutineMode.basic)
                            Text("Reduced").tag(RoutineMode.reduced)
                        }
                        .pickerStyle(.segmented)

                        schedulePreview(for: template)

                        if !notificationStatus.isEmpty {
                            Text(notificationStatus)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        PrimaryButton(title: "Schedule Routine Start Notification") {
                            Task {
                                await scheduleNotification(for: template)
                            }
                        }

                        PrimaryButton(title: "Start Focus Now") {
                            appState.focusMode = selectedMode
                            appState.selectedRoutineTemplateID = template.id
                            appRouter.route(to: .routineFocus)
                        }

                        Text("Tasks")
                            .font(.headline)

                        ForEach(template.tasks.sorted(by: { $0.orderIndex < $1.orderIndex })) { task in
                            Button {
                                appState.selectedRoutineTaskID = task.id
                                appRouter.route(to: .taskEditor)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(task.title)
                                        Text(task.type.rawValue)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("\(task.durationSeconds)s")
                                        .font(.caption)
                                }
                            }
                        }

                        PrimaryButton(title: "Add Task") {
                            appState.selectedRoutineTaskID = nil
                            appRouter.route(to: .taskEditor)
                        }

                        PrimaryButton(title: "Back to Home") {
                            appRouter.route(to: .home)
                        }
                    }
                    .padding()
                }
                .onAppear {
                    endTime = timeFromTemplate(template)
                }
            } else {
                PlaceholderScreen(
                    title: "Routine Setup",
                    subtitle: "Select a routine template first."
                )
            }
        }
    }

    private var selectedTemplate: RoutineTemplateModel? {
        if let selectedID = appState.selectedRoutineTemplateID {
            return templates.first { $0.id == selectedID }
        }
        return templates.first
    }

    private func timeFromTemplate(_ template: RoutineTemplateModel) -> Date {
        Calendar.current.date(bySettingHour: template.routineEndHour, minute: template.routineEndMinute, second: 0, of: .now) ?? .now
    }

    private func updateEndTime(_ value: Date, for template: RoutineTemplateModel) {
        let parts = Calendar.current.dateComponents([.hour, .minute], from: value)
        template.routineEndHour = parts.hour ?? template.routineEndHour
        template.routineEndMinute = parts.minute ?? template.routineEndMinute
        try? modelContext.save()
    }

    @MainActor
    private func scheduleNotification(for template: RoutineTemplateModel) async {
        let plan = scheduleEngine.buildPlan(template: template, mode: selectedMode, for: .now)
        let startAt = max(plan.startAt, Date().addingTimeInterval(5))
        let scheduled = await dependencies.notificationManager.scheduleRoutineStartNotification(
            startAt: startAt,
            mode: selectedMode,
            templateID: template.id
        )
        notificationStatus = scheduled ? "Routine notification scheduled." : "Notification scheduling failed."
    }

    @ViewBuilder
    private func schedulePreview(for template: RoutineTemplateModel) -> some View {
        let plan = scheduleEngine.buildPlan(template: template, mode: selectedMode, for: .now)

        VStack(alignment: .leading, spacing: 8) {
            Text("Schedule Preview")
                .font(.headline)

            Text("Start: \(timeFormatter.string(from: plan.startAt))  End: \(timeFormatter.string(from: plan.endAt))")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ForEach(plan.tasks) { task in
                HStack {
                    Text(task.title)
                    Spacer()
                    Text("\(task.durationSeconds / 60)m")
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }

            if selectedMode == .reduced {
                let basicPlan = scheduleEngine.buildPlan(template: template, mode: .basic, for: .now)
                let isShorter = plan.totalDurationSeconds < basicPlan.totalDurationSeconds
                Text(isShorter ? "Reduced mode is shorter than basic." : "Adjust mode actions to shorten reduced mode.")
                    .font(.caption)
                    .foregroundStyle(isShorter ? .green : .orange)
            }
        }
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}
