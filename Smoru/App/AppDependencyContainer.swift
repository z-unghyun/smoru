import Foundation

final class AppDependencyContainer {
    let healthKitManager = HealthKitManager()
    let notificationManager = NotificationManager()
    let authManager = AuthManager()
    let firebaseClient = FirebaseClient()

    init() {}
}
