import SwiftUI
import SwiftData

struct DateDetailView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appRouter: AppRouter

    @Query(sort: [SortDescriptor(\DailySleepSummaryModel.date, order: .reverse)])
    private var summaries: [DailySleepSummaryModel]

    var body: some View {
        let selectedDate = appState.selectedHistoryDate ?? .now
        let summary = summary(for: selectedDate)

        ScrollView {
            VStack(spacing: 20) {
                Text(dateFormatter.string(from: selectedDate))
                    .font(.title3.weight(.semibold))

                SleepFragmentView(parameters: parameters(for: selectedDate), baseSize: 180)

                if let summary {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Source: \(summary.source.rawValue)")
                        Text("Sleep duration: \(Int(summary.totalSleepMinutes)) min")
                        Text("Wake count: \(summary.wakeCount)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                } else {
                    Text("No stored summary for this day. Showing sample fragment.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                PrimaryButton(title: "Back to History") {
                    appRouter.route(to: .history)
                }
            }
            .padding()
        }
    }

    private func summary(for date: Date) -> DailySleepSummaryModel? {
        let calendar = Calendar.current
        return summaries.first { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private func parameters(for date: Date) -> SleepFragmentParameters {
        if let summary = summary(for: date) {
            let score = SleepConditionScoreEngine().compute(
                input: SleepScoreInput(
                    summary: summary.asDomainData,
                    targetSleepMinutes: 450,
                    morningPreparationScore: 70
                )
            )
            return SleepFragmentParameterEngine().makeParameters(
                from: score,
                totalSleepMinutes: summary.totalSleepMinutes,
                awakeMinutes: summary.awakeMinutes,
                wakeCount: summary.wakeCount,
                targetSleepMinutes: 450
            )
        }
        return DomainSampleData.sampleFragmentParameters(for: date)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
