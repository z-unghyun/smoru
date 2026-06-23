import Foundation

protocol UserProfileRepository {
    func syncProfile(userID: String, provider: AuthProvider, isTrial: Bool) async -> Bool
}

protocol RoutineSettingsRepository {
    func backupRoutine(userID: String, templateID: UUID, payload: [String: String]) async -> Bool
    func backupSettings(userID: String, payload: [String: String]) async -> Bool
}

protocol FeedbackRepository {
    func submitErrorReport(title: String, detail: String, appVersion: String) async -> Bool
    func submitFeatureRequest(title: String, detail: String) async -> Bool
}
