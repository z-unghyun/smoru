import Foundation
import SwiftData

@Model
final class SleepConditionScoreModel {
    var id: UUID
    var date: Date
    var durationScore: Double
    var stabilityScore: Double
    var recoveryScore: Double
    var stageBalanceScore: Double
    var respiratoryStabilityScore: Double
    var dataQualityScore: Double
    var sleepConditionScore: Double
    var morningPreparationScore: Double
    var readinessScore: Double
    var recommendedModeRawValue: String

    init(
        id: UUID = UUID(),
        date: Date,
        durationScore: Double,
        stabilityScore: Double,
        recoveryScore: Double,
        stageBalanceScore: Double,
        respiratoryStabilityScore: Double,
        dataQualityScore: Double,
        sleepConditionScore: Double,
        morningPreparationScore: Double,
        readinessScore: Double,
        recommendedMode: RoutineMode
    ) {
        self.id = id
        self.date = date
        self.durationScore = durationScore
        self.stabilityScore = stabilityScore
        self.recoveryScore = recoveryScore
        self.stageBalanceScore = stageBalanceScore
        self.respiratoryStabilityScore = respiratoryStabilityScore
        self.dataQualityScore = dataQualityScore
        self.sleepConditionScore = sleepConditionScore
        self.morningPreparationScore = morningPreparationScore
        self.readinessScore = readinessScore
        self.recommendedModeRawValue = recommendedMode.rawValue
    }

    var recommendedMode: RoutineMode {
        get { RoutineMode(rawValue: recommendedModeRawValue) ?? .basic }
        set { recommendedModeRawValue = newValue.rawValue }
    }
}
