import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appRouter: AppRouter

    @Query(sort: [SortDescriptor(\DailySleepSummaryModel.date, order: .reverse)])
    private var summaries: [DailySleepSummaryModel]

    var body: some View {
        let todayParameters = currentFragmentParameters

        ScrollView {
            VStack(spacing: 24) {
                SleepFragmentView(parameters: todayParameters)

                VStack(spacing: 8) {
                    Text("Today's Sleep Fragment")
                        .font(.title3.weight(.semibold))

                    if let latest = summaries.first {
                        Text("Source: \(latest.source.rawValue), Sleep: \(Int(latest.totalSleepMinutes)) min")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else if appState.isTrialModeEnabled {
                        Text("Source: sample trial data")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("No summary yet. Complete HealthKit or manual input.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                PrimaryButton(title: "Routine Setup") {
                    appRouter.route(to: .routineTemplateSelection)
                }
                .padding(.horizontal, 20)

                PrimaryButton(title: "Open History") {
                    appRouter.route(to: .history)
                }
                .padding(.horizontal, 20)

                PlaceholderScreen(
                    title: "Home",
                    subtitle: "Today's visual uses integrated Sleep Fragment parameters."
                )
            }
            .padding()
        }
    }

    private var currentFragmentParameters: SleepFragmentParameters {
        if let latest = summaries.first {
            let score = SleepConditionScoreEngine().compute(
                input: SleepScoreInput(
                    summary: latest.asDomainData,
                    targetSleepMinutes: 450,
                    morningPreparationScore: 70
                )
            )
            return SleepFragmentParameterEngine().makeParameters(
                from: score,
                totalSleepMinutes: latest.totalSleepMinutes,
                awakeMinutes: latest.awakeMinutes,
                wakeCount: latest.wakeCount,
                targetSleepMinutes: 450
            )
        }

        return DomainSampleData.sampleFragmentParameters(for: .now)
    }
}
