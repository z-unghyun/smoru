import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: [SortDescriptor(\DailySleepSummaryModel.date, order: .reverse)])
    private var summaries: [DailySleepSummaryModel]

    var body: some View {
        VStack(spacing: 20) {
            SleepFragmentView()

            if let latest = summaries.first {
                VStack(spacing: 8) {
                    Text("Latest sleep source: \(latest.source.rawValue)")
                    Text("Sleep: \(Int(latest.totalSleepMinutes)) min")
                        .font(.headline)
                }
            }

            PlaceholderScreen(
                title: "Home",
                subtitle: "Today's sleep fragment and routine summary placeholder."
            )
        }
    }
}
