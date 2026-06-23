import Foundation

final class AppDependencyContainer {
    let healthKitManager: any HealthKitManaging
    let notificationManager = NotificationManager()
    let authManager = AuthManager()
    let firebaseClient = FirebaseClient()

    init(healthKitManager: any HealthKitManaging = HealthKitManager()) {
        self.healthKitManager = healthKitManager
    }
}
