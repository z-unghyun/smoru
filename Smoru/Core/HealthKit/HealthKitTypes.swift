import Foundation

enum HealthKitAuthorizationResult {
    case authorized
    case denied
    case unavailable
}

enum HealthKitFetchResult {
    case success(DailySleepSummaryData)
    case noData
    case denied
    case unavailable
    case failed(String)
}

protocol HealthKitManaging {
    func isHealthDataAvailable() -> Bool
    func requestAuthorization() async -> HealthKitAuthorizationResult
    func fetchRecentSleepSummary() async -> HealthKitFetchResult
}
