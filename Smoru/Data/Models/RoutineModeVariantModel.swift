import Foundation
import SwiftData

@Model
final class RoutineModeVariantModel {
    var id: UUID
    var modeRawValue: String
    var actionRawValue: String
    var replacementTitle: String?
    var replacementDurationSeconds: Int?

    @Relationship(inverse: \RoutineTaskModel.modeVariants)
    var task: RoutineTaskModel?

    init(
        id: UUID = UUID(),
        mode: RoutineMode,
        action: RoutineTaskModeAction,
        replacementTitle: String? = nil,
        replacementDurationSeconds: Int? = nil
    ) {
        self.id = id
        self.modeRawValue = mode.rawValue
        self.actionRawValue = action.rawValue
        self.replacementTitle = replacementTitle
        self.replacementDurationSeconds = replacementDurationSeconds
    }

    var mode: RoutineMode {
        get { RoutineMode(rawValue: modeRawValue) ?? .basic }
        set { modeRawValue = newValue.rawValue }
    }

    var action: RoutineTaskModeAction {
        get { RoutineTaskModeAction(rawValue: actionRawValue) ?? .keep }
        set { actionRawValue = newValue.rawValue }
    }
}
