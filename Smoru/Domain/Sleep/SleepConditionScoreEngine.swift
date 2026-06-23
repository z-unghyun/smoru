import Foundation

struct SleepConditionScoreEngine {
    private let routineModeEngine: RoutineModeEngine

    init(routineModeEngine: RoutineModeEngine = RoutineModeEngine()) {
        self.routineModeEngine = routineModeEngine
    }

    func compute(input: SleepScoreInput) -> SleepConditionComputation {
        let durationRatio = clamp(input.summary.totalSleepMinutes / max(input.targetSleepMinutes, 1), lower: 0, upper: 1.4)
        let durationScore = clamp(100 * durationRatio, lower: 0, upper: 100)

        let wakePenalty = Double(input.summary.wakeCount) * 8 + (input.summary.awakeMinutes * 0.4)
        let stabilityScore = clamp(100 - wakePenalty, lower: 0, upper: 100)

        let hrvScore = clamp((input.summary.hrvSDNN - 20) * 2.0, lower: 0, upper: 100)
        let heartRatePenalty = clamp((input.summary.averageHeartRate - 55) * 1.5, lower: 0, upper: 35)
        let recoveryScore = clamp(hrvScore - heartRatePenalty, lower: 0, upper: 100)

        let stageBalanceScore = clamp(input.summary.sleepEfficiency * 100, lower: 0, upper: 100)

        let respiratoryDelta = abs(input.summary.respiratoryRate - 14)
        let respiratoryStabilityScore = clamp(100 - (respiratoryDelta * 7.5), lower: 0, upper: 100)

        let dataQualityScore = clamp(input.summary.dataQualityScore, lower: 0, upper: 100)

        let sleepConditionScore = weightedAverage(
            values: [durationScore, stabilityScore, recoveryScore, stageBalanceScore, respiratoryStabilityScore, dataQualityScore],
            weights: [0.25, 0.2, 0.2, 0.15, 0.1, 0.1]
        )

        let morningPreparationScore = clamp(input.morningPreparationScore, lower: 0, upper: 100)
        let readinessScore = (sleepConditionScore * 0.8) + (morningPreparationScore * 0.2)
        let mode = routineModeEngine.selectMode(readinessScore: readinessScore)

        return SleepConditionComputation(
            date: input.summary.date,
            durationScore: durationScore,
            stabilityScore: stabilityScore,
            recoveryScore: recoveryScore,
            stageBalanceScore: stageBalanceScore,
            respiratoryStabilityScore: respiratoryStabilityScore,
            dataQualityScore: dataQualityScore,
            sleepConditionScore: sleepConditionScore,
            morningPreparationScore: morningPreparationScore,
            readinessScore: readinessScore,
            mode: mode
        )
    }

    private func clamp(_ value: Double, lower: Double, upper: Double) -> Double {
        min(max(value, lower), upper)
    }

    private func weightedAverage(values: [Double], weights: [Double]) -> Double {
        guard values.count == weights.count, !values.isEmpty else { return 0 }
        let weighted = zip(values, weights).reduce(0) { partial, pair in
            partial + (pair.0 * pair.1)
        }
        let divisor = max(weights.reduce(0, +), 0.0001)
        return weighted / divisor
    }
}
