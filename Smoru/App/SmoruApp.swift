import SwiftUI
import SwiftData

@main
struct SmoruApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var appRouter = AppRouter()
    private let dependencies = AppDependencyContainer()
    private let modelContainer: ModelContainer

    init() {
        let schema = Schema([
            UserSettingsModel.self,
            DailySleepSummaryModel.self,
            SleepConditionScoreModel.self,
            SleepFragmentParametersModel.self,
            RoutineTemplateModel.self,
            RoutineTaskModel.self,
            RoutineModeVariantModel.self,
            RoutineSessionModel.self,
            RoutineTaskRecordModel.self,
            NightChecklistItemModel.self,
            NightChecklistRecordModel.self,
            ManualConditionInputModel.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to build ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            SmoruRootView()
                .environmentObject(appState)
                .environmentObject(appRouter)
                .environment(\.appDependencies, dependencies)
                .task {
                    configureNotificationRoutingOnce()
                }
        }
        .modelContainer(modelContainer)
    }

    @MainActor
    private func configureNotificationRoutingOnce() {
        dependencies.notificationManager.configureRouteHandler { mode, templateID in
            DispatchQueue.main.async {
                appState.focusMode = mode
                if let templateID {
                    appState.selectedRoutineTemplateID = templateID
                }
                appRouter.route(to: .routineFocus)
            }
        }
    }
}
