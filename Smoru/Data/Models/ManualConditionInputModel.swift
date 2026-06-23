import Foundation
import SwiftData

@Model
final class ManualConditionInputModel {
    var id: UUID
    var date: Date
    var sleepMinutes: Double
    var restedScore: Double
    var wakeOften: Bool
    var selectedModeRawValue: String
    var note: String?

    init(
        id: UUID = UUID(),
        date: Date,
        sleepMinutes: Double,
        restedScore: Double,
        wakeOften: Bool,
        selectedMode: RoutineMode,
        note: String? = nil
    ) {
        self.id = id
        self.date = date
        self.sleepMinutes = sleepMinutes
        self.restedScore = restedScore
        self.wakeOften = wakeOften
        self.selectedModeRawValue = selectedMode.rawValue
        self.note = note
    }

    var selectedMode: RoutineMode {
        get { RoutineMode(rawValue: selectedModeRawValue) ?? .basic }
        set { selectedModeRawValue = newValue.rawValue }
    }
}
