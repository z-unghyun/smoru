import Foundation

struct FirebasePlaceholderConfig {
    let projectID: String
    let appID: String
    let apiKeyPlaceholder: String

    static let example = FirebasePlaceholderConfig(
        projectID: "example-smoru-project",
        appID: "1:0000000000:ios:example",
        apiKeyPlaceholder: "REPLACE_WITH_LOCAL_CONFIG"
    )
}

final class FirebaseClient {
    private let config: FirebasePlaceholderConfig

    init(config: FirebasePlaceholderConfig = .example) {
        self.config = config
    }

    func configureIfNeeded() {
        AppLogger.log("Firebase placeholder configured for project: \(config.projectID)")
    }

    func syncUserProfile(userID: String, provider: String, isTrial: Bool) async -> Bool {
        AppLogger.log("Placeholder sync users/{userId} profile. provider=\(provider), trial=\(isTrial)")
        return true
    }

    func backupRoutineSettings(userID: String, templateID: UUID, payload: [String: String]) async -> Bool {
        AppLogger.log("Placeholder backup users/{userId}/routineBackups/{routineId}")
        return true
    }

    func backupAppSettings(userID: String, payload: [String: String]) async -> Bool {
        AppLogger.log("Placeholder backup users/{userId}/settings/current")
        return true
    }

    func submitErrorReport(payload: [String: String]) async -> Bool {
        AppLogger.log("Placeholder write errorReports/{reportId}")
        return true
    }

    func submitFeatureRequest(payload: [String: String]) async -> Bool {
        AppLogger.log("Placeholder write featureRequests/{requestId}")
        return true
    }

    func trackEvent(label: String) async {
        AppLogger.log("Placeholder analytics event: \(label)")
    }
}
