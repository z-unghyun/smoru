import SwiftUI

struct SmoruRootView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appRouter: AppRouter

    var body: some View {
        Group {
            switch appRouter.currentRoute {
            case .entry:
                EntryView()
            case .trialHome:
                TrialHomeView()
            case .healthKitIntro:
                HealthKitIntroView()
            case .healthKitPermissionState:
                HealthKitPermissionStateView()
            case .manualConditionInput:
                ManualConditionInputView()
            case .home:
                HomeView()
            case .sleepReport:
                SleepReportView()
            case .routineTemplateSelection:
                RoutineTemplateSelectionView()
            case .routineSetup:
                RoutineSetupView()
            case .taskEditor:
                TaskEditorView()
            case .routineFocus:
                RoutineFocusView()
            case .history:
                HistoryView()
            case .dateDetail:
                DateDetailView()
            case .settings:
                SettingsView()
            case .privacyData:
                PrivacyDataView()
            case .errorReport:
                ErrorReportView()
            case .featureRequest:
                FeatureRequestView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: appRouter.currentRoute)
    }
}
