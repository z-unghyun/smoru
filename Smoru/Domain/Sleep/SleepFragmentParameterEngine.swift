import Foundation

struct SleepFragmentParameterEngine {
    func makeParameters(
        from score: SleepConditionComputation,
        totalSleepMinutes: Double,
        awakeMinutes: Double,
        wakeCount: Int,
        targetSleepMinutes: Double = 450
    ) -> SleepFragmentParameters {
        let durationRatio = clamp(totalSleepMinutes / max(targetSleepMinutes, 1), lower: 0.70, upper: 1.20)
        let wakeCountPenalty = Double(wakeCount) * 6
        let lowEfficiencyPenalty = max(0, 90 - score.stageBalanceScore)
        let edgeRoughness = normalize(awakeMinutes + wakeCountPenalty + lowEfficiencyPenalty, min: 0, max: 180)
        let colorProgress = clamp(score.sleepConditionScore / 100, lower: 0, upper: 1)
        let symmetry = normalize(score.stabilityScore, min: 0, max: 100)
        let innerGlow = normalize(score.recoveryScore, min: 0, max: 100)
        let surfaceVibration = inverseNormalize(score.stabilityScore, min: 0, max: 100)
        let roundness = normalize(score.respiratoryStabilityScore, min: 0, max: 100)
        let qualityRatio = normalize(score.dataQualityScore, min: 0, max: 100)
        let opacity = 0.35 + (qualityRatio * 0.65)
        let sharpness = 0.25 + (qualityRatio * 0.75)

        return SleepFragmentParameters(
            date: score.date,
            totalScore: score.sleepConditionScore,
            durationRatio: durationRatio,
            edgeRoughness: edgeRoughness,
            colorProgress: colorProgress,
            symmetry: symmetry,
            innerGlow: innerGlow,
            surfaceVibration: surfaceVibration,
            roundness: roundness,
            opacity: opacity,
            sharpness: sharpness,
            seed: stableSeed(for: score.date)
        )
    }

    func stableSeed(for date: Date, calendar: Calendar = .current) -> Int {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        return (year * 10_000) + (month * 100) + day
    }

    private func clamp(_ value: Double, lower: Double, upper: Double) -> Double {
        min(max(value, lower), upper)
    }

    private func normalize(_ value: Double, min: Double, max: Double) -> Double {
        guard max > min else { return 0 }
        return clamp((value - min) / (max - min), lower: 0, upper: 1)
    }

    private func inverseNormalize(_ value: Double, min: Double, max: Double) -> Double {
        1 - normalize(value, min: min, max: max)
    }
}
