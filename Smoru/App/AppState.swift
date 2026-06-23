import Foundation

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
}
