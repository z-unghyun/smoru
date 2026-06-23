import SwiftUI
import SwiftData

struct HealthKitPermissionStateView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var appState: AppState
    @Environment(\.appDependencies) private var dependencies
    @Environment(\.modelContext) private var modelContext

    @State private var isWorking = false

    var body: some View {
        VStack(spacing: 16) {
            PlaceholderScreen(
                title: "Health Permission",
                subtitle: statusMessage
            )

            if isWorking {
                ProgressView()
            }

            PrimaryButton(title: "Request Apple Health Permission") {
                Task {
                    await runPermissionFlow()
                }
            }
            .padding(.horizontal, 24)
            .disabled(isWorking)

            Button("Use manual input") {
                appRouter.route(to: .manualConditionInput)
            }
            .buttonStyle(.bordered)
        }
    }

    private var statusMessage: String {
        if appState.healthKitStatusMessage.isEmpty {
            return "Permission has not been requested yet."
        }
        return appState.healthKitStatusMessage
    }

    @MainActor
    private func runPermissionFlow() async {
        isWorking = true
        appState.healthKitPermissionState = .requesting
        appState.healthKitStatusMessage = "Requesting permission..."

        let manager = dependencies.healthKitManager

        guard manager.isHealthDataAvailable() else {
            appState.healthKitPermissionState = .unavailable
            appState.healthKitStatusMessage = "Apple Health is unavailable on this device."
            isWorking = false
            appRouter.route(to: .manualConditionInput)
            return
        }

        let authResult = await manager.requestAuthorization()
        switch authResult {
        case .authorized:
            appState.healthKitPermissionState = .authorized
            appState.healthKitStatusMessage = "Permission granted. Loading recent sleep data..."
        case .denied:
            appState.healthKitPermissionState = .denied
            appState.healthKitStatusMessage = "Permission denied. You can continue with manual input."
            isWorking = false
            appRouter.route(to: .manualConditionInput)
            return
        case .unavailable:
            appState.healthKitPermissionState = .unavailable
            appState.healthKitStatusMessage = "Apple Health is unavailable."
            isWorking = false
            appRouter.route(to: .manualConditionInput)
            return
        }

        let fetchResult = await manager.fetchRecentSleepSummary()
        handleFetchResult(fetchResult)
        isWorking = false
    }

    @MainActor
    private func handleFetchResult(_ fetchResult: HealthKitFetchResult) {
        switch fetchResult {
        case .success(let summary):
            let model = DailySleepSummaryModel(
                date: summary.date,
                source: summary.source,
                totalSleepMinutes: summary.totalSleepMinutes,
                awakeMinutes: summary.awakeMinutes,
                wakeCount: summary.wakeCount,
                sleepEfficiency: summary.sleepEfficiency,
                averageHeartRate: summary.averageHeartRate,
                hrvSDNN: summary.hrvSDNN,
                respiratoryRate: summary.respiratoryRate,
                stepCount: summary.stepCount,
                dataQualityScore: summary.dataQualityScore
            )
            modelContext.insert(model)
            try? modelContext.save()

            appState.healthKitPermissionState = .authorized
            appState.healthKitStatusMessage = "Recent sleep data loaded successfully."
            appRouter.route(to: .home)

        case .noData:
            appState.healthKitPermissionState = .noData
            appState.healthKitStatusMessage = "No recent sleep data was found."
            appRouter.route(to: .manualConditionInput)

        case .denied:
            appState.healthKitPermissionState = .denied
            appState.healthKitStatusMessage = "Permission is not authorized."
            appRouter.route(to: .manualConditionInput)

        case .unavailable:
            appState.healthKitPermissionState = .unavailable
            appState.healthKitStatusMessage = "Apple Health is unavailable."
            appRouter.route(to: .manualConditionInput)

        case .failed:
            appState.healthKitPermissionState = .noData
            appState.healthKitStatusMessage = "Could not read sleep data. Use manual input."
            appRouter.route(to: .manualConditionInput)
        }
    }
}
