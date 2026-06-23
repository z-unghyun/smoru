import Foundation
import SwiftData

@Model
final class UserSettingsModel {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var notificationsEnabled: Bool
    var voiceGuideEnabled: Bool
    var routineEndHour: Int
    var routineEndMinute: Int
    var preferredModeRawValue: String?
    var targetSleepMinutes: Double

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        updatedAt: Date = .now,
        notificationsEnabled: Bool = true,
        voiceGuideEnabled: Bool = true,
        routineEndHour: Int = 8,
        routineEndMinute: Int = 30,
        preferredModeRawValue: String? = nil,
        targetSleepMinutes: Double = 450
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.notificationsEnabled = notificationsEnabled
        self.voiceGuideEnabled = voiceGuideEnabled
        self.routineEndHour = routineEndHour
        self.routineEndMinute = routineEndMinute
        self.preferredModeRawValue = preferredModeRawValue
        self.targetSleepMinutes = targetSleepMinutes
    }

    var preferredMode: RoutineMode? {
        get { preferredModeRawValue.flatMap(RoutineMode.init(rawValue:)) }
        set { preferredModeRawValue = newValue?.rawValue }
    }
}
