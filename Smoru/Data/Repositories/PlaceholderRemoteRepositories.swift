import Foundation

final class PlaceholderUserProfileRepository: UserProfileRepository {
    private let firebaseClient: FirebaseClient

    init(firebaseClient: FirebaseClient) {
        self.firebaseClient = firebaseClient
    }

    func syncProfile(userID: String, provider: AuthProvider, isTrial: Bool) async -> Bool {
        await firebaseClient.syncUserProfile(userID: userID, provider: provider.rawValue, isTrial: isTrial)
    }
}

final class PlaceholderRoutineSettingsRepository: RoutineSettingsRepository {
    private let firebaseClient: FirebaseClient

    init(firebaseClient: FirebaseClient) {
        self.firebaseClient = firebaseClient
    }

    func backupRoutine(userID: String, templateID: UUID, payload: [String: String]) async -> Bool {
        await firebaseClient.backupRoutineSettings(userID: userID, templateID: templateID, payload: payload)
    }

    func backupSettings(userID: String, payload: [String: String]) async -> Bool {
        await firebaseClient.backupAppSettings(userID: userID, payload: payload)
    }
}

final class PlaceholderFeedbackRepository: FeedbackRepository {
    private let firebaseClient: FirebaseClient

    init(firebaseClient: FirebaseClient) {
        self.firebaseClient = firebaseClient
    }

    func submitErrorReport(title: String, detail: String, appVersion: String) async -> Bool {
        await firebaseClient.submitErrorReport(payload: [
            "title": title,
            "detail": detail,
            "appVersion": appVersion
        ])
    }

    func submitFeatureRequest(title: String, detail: String) async -> Bool {
        await firebaseClient.submitFeatureRequest(payload: [
            "title": title,
            "detail": detail
        ])
    }
}
