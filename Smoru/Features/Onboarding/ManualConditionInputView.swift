import SwiftUI
import SwiftData

struct ManualConditionInputView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appRouter: AppRouter

    @State private var sleepMinutes: Double = 420
    @State private var restedScore: Double = 70
    @State private var wakeOften: Bool = false
    @State private var selectedMode: RoutineMode = .basic

    var body: some View {
        Form {
            Section("Manual Sleep Input") {
                VStack(alignment: .leading) {
                    Text("Sleep duration: \(Int(sleepMinutes)) min")
                    Slider(value: $sleepMinutes, in: 120...720, step: 5)
                }

                VStack(alignment: .leading) {
                    Text("How rested do you feel: \(Int(restedScore))")
                    Slider(value: $restedScore, in: 0...100, step: 1)
                }

                Toggle("Did you wake up often?", isOn: $wakeOften)

                Picker("Today mode", selection: $selectedMode) {
                    Text("Expanded").tag(RoutineMode.expanded)
                    Text("Basic").tag(RoutineMode.basic)
                    Text("Reduced").tag(RoutineMode.reduced)
                }
                .pickerStyle(.segmented)
            }

            Section {
                Button("Save and Continue") {
                    saveManualSummary()
                    appRouter.route(to: .home)
                }
            }
        }
    }

    private func saveManualSummary() {
        let wakeCount = wakeOften ? 3 : 1
        let awakeMinutes = wakeOften ? 45.0 : 15.0
        let summary = DailySleepSummaryModel(
            date: .now,
            source: .manual,
            totalSleepMinutes: sleepMinutes,
            awakeMinutes: awakeMinutes,
            wakeCount: wakeCount,
            sleepEfficiency: max(0.5, min((sleepMinutes - awakeMinutes) / max(sleepMinutes, 1), 1.0)),
            averageHeartRate: 0,
            hrvSDNN: 0,
            respiratoryRate: 0,
            stepCount: 0,
            dataQualityScore: 55
        )
        modelContext.insert(summary)

        let manual = ManualConditionInputModel(
            date: .now,
            sleepMinutes: sleepMinutes,
            restedScore: restedScore,
            wakeOften: wakeOften,
            selectedMode: selectedMode,
            note: "Manual fallback input"
        )
        modelContext.insert(manual)

        try? modelContext.save()
    }
}
