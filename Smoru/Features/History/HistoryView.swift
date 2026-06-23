import SwiftUI
import SwiftData

struct HistoryView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appRouter: AppRouter

    @Query(sort: [SortDescriptor(\DailySleepSummaryModel.date, order: .reverse)])
    private var summaries: [DailySleepSummaryModel]

    private let columns = [
        GridItem(.flexible(minimum: 68), spacing: 14),
        GridItem(.flexible(minimum: 68), spacing: 14),
        GridItem(.flexible(minimum: 68), spacing: 14),
        GridItem(.flexible(minimum: 68), spacing: 14)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Monthly Sleep Fragment History")
                    .font(.title3.weight(.semibold))

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(monthlyDates, id: \.self) { date in
                        Button {
                            appState.selectedHistoryDate = date
                            appRouter.route(to: .dateDetail)
                        } label: {
                            VStack(spacing: 6) {
                                SleepFragmentView(parameters: fragmentParameters(for: date), baseSize: 54)
                                Text(dayFormatter.string(from: date))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
    }

    private var monthlyDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return (0..<30).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)
        }
    }

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }

    private func fragmentParameters(for date: Date) -> SleepFragmentParameters {
        let calendar = Calendar.current
        if let summary = summaries.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
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
}
