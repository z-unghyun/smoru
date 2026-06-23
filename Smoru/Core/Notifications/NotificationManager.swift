import Foundation
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    private let center = UNUserNotificationCenter.current()
    private var isConfigured = false
    private var routeHandler: ((RoutineMode, UUID?) -> Void)?

    override init() {
        super.init()
        configureCenterIfNeeded()
    }

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            return false
        }
    }

    func configureRouteHandler(_ handler: @escaping (RoutineMode, UUID?) -> Void) {
        routeHandler = handler
    }

    func scheduleRoutineStartNotification(startAt: Date, mode: RoutineMode, templateID: UUID?) async -> Bool {
        guard await requestAuthorization() else {
            return false
        }

        let content = UNMutableNotificationContent()
        content.title = "SMORU Routine Start"
        content.body = "Time to begin your \(mode.rawValue) routine."
        content.sound = .default
        content.userInfo = [
            "type": "routineStart",
            "mode": mode.rawValue,
            "templateID": templateID?.uuidString ?? ""
        ]

        let triggerDate = max(startAt.timeIntervalSinceNow, 5)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: "smoru.routineStart.\(UUID().uuidString)", content: content, trigger: trigger)

        do {
            try await center.add(request)
            return true
        } catch {
            return false
        }
    }

    private func configureCenterIfNeeded() {
        guard !isConfigured else { return }
        center.delegate = self
        isConfigured = true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        handleNotificationPayload(userInfo)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }

    private func handleNotificationPayload(_ userInfo: [AnyHashable: Any]) {
        guard let type = userInfo["type"] as? String, type == "routineStart" else {
            return
        }

        let modeRawValue = userInfo["mode"] as? String
        let mode = RoutineMode(rawValue: modeRawValue ?? "") ?? .basic

        let templateIDString = userInfo["templateID"] as? String
        let templateID = templateIDString.flatMap { UUID(uuidString: $0) }

        routeHandler?(mode, templateID)
    }
}
