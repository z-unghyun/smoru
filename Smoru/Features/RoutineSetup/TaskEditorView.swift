import SwiftUI
import SwiftData

struct TaskEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appRouter: AppRouter

    @Query(sort: [SortDescriptor(\RoutineTemplateModel.createdAt, order: .forward)])
    private var templates: [RoutineTemplateModel]

    @State private var title: String = ""
    @State private var taskType: RoutineTaskType = .basic
    @State private var durationSeconds: Int = 300
    @State private var isEssential: Bool = false
    @State private var launchURLString: String = ""
    @State private var fallbackURLString: String = ""
    @State private var appDisplayName: String = ""

    @State private var expandedAction: RoutineTaskModeAction = .keep
    @State private var basicAction: RoutineTaskModeAction = .keep
    @State private var reducedAction: RoutineTaskModeAction = .keep

    @State private var expandedReplacementSeconds: Int = 600
    @State private var basicReplacementSeconds: Int = 300
    @State private var reducedReplacementSeconds: Int = 180

    var body: some View {
        Form {
            Section("Task") {
                TextField("Title", text: $title)

                Picker("Task Type", selection: $taskType) {
                    Text("Basic").tag(RoutineTaskType.basic)
                    Text("Alarm-like").tag(RoutineTaskType.alarmLike)
                    Text("Multi-timer").tag(RoutineTaskType.multiTimer)
                    Text("App Open").tag(RoutineTaskType.appOpen)
                    Text("Link Open").tag(RoutineTaskType.linkOpen)
                }

                Stepper("Duration: \(durationSeconds)s", value: $durationSeconds, in: 30...3600, step: 30)
                Toggle("Essential task", isOn: $isEssential)

                TextField("Launch URL (optional)", text: $launchURLString)
                TextField("Fallback URL (optional)", text: $fallbackURLString)
                TextField("App display name (optional)", text: $appDisplayName)
            }

            Section("Mode Behavior") {
                modeBehaviorEditor(label: "Expanded", action: $expandedAction, replacementSeconds: $expandedReplacementSeconds)
                modeBehaviorEditor(label: "Basic", action: $basicAction, replacementSeconds: $basicReplacementSeconds)
                modeBehaviorEditor(label: "Reduced", action: $reducedAction, replacementSeconds: $reducedReplacementSeconds)
            }

            Section {
                Button("Save Task") {
                    saveTask()
                    appRouter.route(to: .routineSetup)
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear {
            loadExistingTaskIfNeeded()
        }
    }

    @ViewBuilder
    private func modeBehaviorEditor(label: String, action: Binding<RoutineTaskModeAction>, replacementSeconds: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("\(label) action", selection: action) {
                Text("Keep").tag(RoutineTaskModeAction.keep)
                Text("Replace").tag(RoutineTaskModeAction.replace)
                Text("Skip").tag(RoutineTaskModeAction.skip)
            }
            .pickerStyle(.segmented)

            if action.wrappedValue == .replace {
                Stepper("\(label) replacement: \(replacementSeconds.wrappedValue)s", value: replacementSeconds, in: 30...3600, step: 30)
            }
        }
    }

    private var selectedTemplate: RoutineTemplateModel? {
        if let id = appState.selectedRoutineTemplateID {
            return templates.first { $0.id == id }
        }
        return templates.first
    }

    private func loadExistingTaskIfNeeded() {
        guard let template = selectedTemplate,
              let taskID = appState.selectedRoutineTaskID,
              let task = template.tasks.first(where: { $0.id == taskID }) else {
            return
        }

        title = task.title
        taskType = task.type
        durationSeconds = task.durationSeconds
        isEssential = task.isEssential
        launchURLString = task.launchURLString ?? ""
        fallbackURLString = task.fallbackURLString ?? ""
        appDisplayName = task.appDisplayName ?? ""

        applyVariant(task.variant(for: .expanded), to: &expandedAction, replacement: &expandedReplacementSeconds)
        applyVariant(task.variant(for: .basic), to: &basicAction, replacement: &basicReplacementSeconds)
        applyVariant(task.variant(for: .reduced), to: &reducedAction, replacement: &reducedReplacementSeconds)
    }

    private func applyVariant(_ variant: RoutineModeVariantModel?, to action: inout RoutineTaskModeAction, replacement: inout Int) {
        action = variant?.action ?? .keep
        replacement = variant?.replacementDurationSeconds ?? replacement
    }

    private func saveTask() {
        guard let template = selectedTemplate else { return }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let editingTask = appState.selectedRoutineTaskID.flatMap { id in
            template.tasks.first { $0.id == id }
        }

        let task = editingTask ?? RoutineTaskModel(
            orderIndex: template.tasks.count,
            title: trimmedTitle,
            type: taskType,
            durationSeconds: durationSeconds,
            isEssential: isEssential
        )

        task.title = trimmedTitle
        task.type = taskType
        task.durationSeconds = durationSeconds
        task.isEssential = isEssential
        task.launchURLString = launchURLString.isEmpty ? nil : launchURLString
        task.fallbackURLString = fallbackURLString.isEmpty ? nil : fallbackURLString
        task.appDisplayName = appDisplayName.isEmpty ? nil : appDisplayName

        upsertVariant(for: task, mode: .expanded, action: expandedAction, replacementSeconds: expandedReplacementSeconds)
        upsertVariant(for: task, mode: .basic, action: basicAction, replacementSeconds: basicReplacementSeconds)
        upsertVariant(for: task, mode: .reduced, action: reducedAction, replacementSeconds: reducedReplacementSeconds)

        if editingTask == nil {
            task.template = template
            template.tasks.append(task)
            modelContext.insert(task)
        }

        try? modelContext.save()
    }

    private func upsertVariant(for task: RoutineTaskModel, mode: RoutineMode, action: RoutineTaskModeAction, replacementSeconds: Int) {
        if let existing = task.modeVariants.first(where: { $0.mode == mode }) {
            existing.action = action
            existing.replacementTitle = action == .replace ? "\(task.title) (\(mode.rawValue))" : nil
            existing.replacementDurationSeconds = action == .replace ? replacementSeconds : nil
            return
        }

        let variant = RoutineModeVariantModel(
            mode: mode,
            action: action,
            replacementTitle: action == .replace ? "\(task.title) (\(mode.rawValue))" : nil,
            replacementDurationSeconds: action == .replace ? replacementSeconds : nil
        )
        variant.task = task
        task.modeVariants.append(variant)
        modelContext.insert(variant)
    }
}

private extension RoutineTaskModel {
    func variant(for mode: RoutineMode) -> RoutineModeVariantModel? {
        modeVariants.first { $0.mode == mode }
    }
}
