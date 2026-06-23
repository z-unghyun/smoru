import Foundation

final class AppDependencyContainer {
    let healthKitManager: any HealthKitManaging
    let notificationManager = NotificationManager()
    let firebaseClient: FirebaseClient
    let authManager: AuthManager

    init(healthKitManager: any HealthKitManaging = HealthKitManager()) {
        self.healthKitManager = healthKitManager
        self.firebaseClient = FirebaseClient()
        self.authManager = AuthManager(firebaseClient: firebaseClient)
    }
}
