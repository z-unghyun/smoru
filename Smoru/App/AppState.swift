import Foundation
import Combine

enum HealthKitPermissionState: String {
    case notDetermined
    case requesting
    case authorized
    case denied
    case unavailable
    case noData
}

final class AppState: ObservableObject {
    @Published var isTrialModeEnabled: Bool = false
    @Published var hasCompletedOnboarding: Bool = false
    @Published var healthKitPermissionState: HealthKitPermissionState = .notDetermined
    @Published var healthKitStatusMessage: String = ""
    @Published var selectedHistoryDate: Date?
    @Published var selectedRoutineTemplateID: UUID?
    @Published var selectedRoutineTaskID: UUID?
    @Published var focusMode: RoutineMode = .basic
}
