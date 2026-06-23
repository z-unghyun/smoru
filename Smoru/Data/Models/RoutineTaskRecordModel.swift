import Foundation
import SwiftData

@Model
final class RoutineTaskRecordModel {
    var id: UUID
    var taskId: UUID
    var taskTitle: String
    var taskTypeRawValue: String
    var plannedDurationSeconds: Int
    var actualDurationSeconds: Int
    var progressStateRawValue: String
    var startedAt: Date?
    var endedAt: Date?

    init(
        id: UUID = UUID(),
        taskId: UUID,
        taskTitle: String,
        taskType: RoutineTaskType,
        plannedDurationSeconds: Int,
        actualDurationSeconds: Int,
        progressState: RoutineTaskProgressState,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) {
        self.id = id
        self.taskId = taskId
        self.taskTitle = taskTitle
        self.taskTypeRawValue = taskType.rawValue
        self.plannedDurationSeconds = plannedDurationSeconds
        self.actualDurationSeconds = actualDurationSeconds
        self.progressStateRawValue = progressState.rawValue
        self.startedAt = startedAt
        self.endedAt = endedAt
    }

    var taskType: RoutineTaskType {
        get { RoutineTaskType(rawValue: taskTypeRawValue) ?? .basic }
        set { taskTypeRawValue = newValue.rawValue }
    }

    var progressState: RoutineTaskProgressState {
        get { RoutineTaskProgressState(rawValue: progressStateRawValue) ?? .pending }
        set { progressStateRawValue = newValue.rawValue }
    }
}
