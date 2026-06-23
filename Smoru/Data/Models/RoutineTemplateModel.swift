import Foundation
import SwiftData

@Model
final class RoutineTemplateModel {
    var id: UUID
    var name: String
    var createdAt: Date
    var updatedAt: Date
    var routineEndHour: Int
    var routineEndMinute: Int
    var voiceGuideEnabled: Bool
    var notificationEnabled: Bool

    @Relationship(deleteRule: .cascade, inverse: \RoutineTaskModel.template)
    var tasks: [RoutineTaskModel]

    init(
        id: UUID = UUID(),
        name: String,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        routineEndHour: Int = 8,
        routineEndMinute: Int = 30,
        voiceGuideEnabled: Bool = true,
        notificationEnabled: Bool = true,
        tasks: [RoutineTaskModel] = []
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.routineEndHour = routineEndHour
        self.routineEndMinute = routineEndMinute
        self.voiceGuideEnabled = voiceGuideEnabled
        self.notificationEnabled = notificationEnabled
        self.tasks = tasks
    }
}
