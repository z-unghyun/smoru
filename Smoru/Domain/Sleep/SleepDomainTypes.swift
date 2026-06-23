import Foundation

struct DailySleepSummaryData {
    var date: Date
    var source: SleepDataSource
    var totalSleepMinutes: Double
    var awakeMinutes: Double
    var wakeCount: Int
    var sleepEfficiency: Double
    var averageHeartRate: Double
    var hrvSDNN: Double
    var respiratoryRate: Double
    var stepCount: Double
    var dataQualityScore: Double
}

struct SleepScoreInput {
    var summary: DailySleepSummaryData
    var targetSleepMinutes: Double
    var morningPreparationScore: Double
}

struct SleepConditionComputation {
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
    var mode: RoutineMode
}

struct SleepFragmentParameters: Codable, Equatable {
    var date: Date
    var totalScore: Double
    var durationRatio: Double
    var edgeRoughness: Double
    var colorProgress: Double
    var symmetry: Double
    var innerGlow: Double
    var surfaceVibration: Double
    var roundness: Double
    var opacity: Double
    var sharpness: Double
    var seed: Int
}
