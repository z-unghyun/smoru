import Foundation
import SwiftData

@Model
final class RoutineTaskModel {
    var id: UUID
    var orderIndex: Int
    var title: String
    var typeRawValue: String
    var durationSeconds: Int
    var isEssential: Bool
    var launchURLString: String?
    var fallbackURLString: String?
    var appDisplayName: String?
    var multiTimerCount: Int
    var multiTimerStepSeconds: Int

    @Relationship(inverse: \RoutineTemplateModel.tasks)
    var template: RoutineTemplateModel?

    @Relationship(deleteRule: .cascade, inverse: \RoutineModeVariantModel.task)
    var modeVariants: [RoutineModeVariantModel]

    init(
        id: UUID = UUID(),
        orderIndex: Int,
        title: String,
        type: RoutineTaskType,
        durationSeconds: Int,
        isEssential: Bool = false,
        launchURLString: String? = nil,
        fallbackURLString: String? = nil,
        appDisplayName: String? = nil,
        multiTimerCount: Int = 1,
        multiTimerStepSeconds: Int = 0,
        modeVariants: [RoutineModeVariantModel] = []
    ) {
        self.id = id
        self.orderIndex = orderIndex
        self.title = title
        self.typeRawValue = type.rawValue
        self.durationSeconds = durationSeconds
        self.isEssential = isEssential
        self.launchURLString = launchURLString
        self.fallbackURLString = fallbackURLString
        self.appDisplayName = appDisplayName
        self.multiTimerCount = multiTimerCount
        self.multiTimerStepSeconds = multiTimerStepSeconds
        self.modeVariants = modeVariants
    }

    var type: RoutineTaskType {
        get { RoutineTaskType(rawValue: typeRawValue) ?? .basic }
        set { typeRawValue = newValue.rawValue }
    }
}
