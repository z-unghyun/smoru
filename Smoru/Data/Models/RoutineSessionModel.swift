import Foundation
import SwiftData

@Model
final class RoutineSessionModel {
    var id: UUID
    var date: Date
    var modeRawValue: String
    var stateRawValue: String
    var startedAt: Date?
    var endedAt: Date?
    var currentTaskIndex: Int
    var totalPlannedSeconds: Int
    var elapsedSeconds: Int

    init(
        id: UUID = UUID(),
        date: Date,
        mode: RoutineMode,
        state: RoutineSessionState,
        startedAt: Date? = nil,
        endedAt: Date? = nil,
        currentTaskIndex: Int = 0,
        totalPlannedSeconds: Int = 0,
        elapsedSeconds: Int = 0
    ) {
        self.id = id
        self.date = date
        self.modeRawValue = mode.rawValue
        self.stateRawValue = state.rawValue
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.currentTaskIndex = currentTaskIndex
        self.totalPlannedSeconds = totalPlannedSeconds
        self.elapsedSeconds = elapsedSeconds
    }

    var mode: RoutineMode {
        get { RoutineMode(rawValue: modeRawValue) ?? .basic }
        set { modeRawValue = newValue.rawValue }
    }

    var state: RoutineSessionState {
        get { RoutineSessionState(rawValue: stateRawValue) ?? .scheduled }
        set { stateRawValue = newValue.rawValue }
    }
}
