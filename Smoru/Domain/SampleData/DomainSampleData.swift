import Foundation

struct DomainSampleData {
    static func makeTemplate() -> RoutineTemplateModel {
        let template = RoutineTemplateModel(
            name: "Sample Morning",
            routineEndHour: 8,
            routineEndMinute: 30,
            voiceGuideEnabled: true,
            notificationEnabled: true
        )

        let hydrate = RoutineTaskModel(orderIndex: 0, title: "Hydrate", type: .basic, durationSeconds: 300, isEssential: true)
        let stretch = RoutineTaskModel(orderIndex: 1, title: "Stretch", type: .basic, durationSeconds: 900)
        let planDay = RoutineTaskModel(orderIndex: 2, title: "Plan Day", type: .basic, durationSeconds: 600, isEssential: true)

        stretch.modeVariants = [
            RoutineModeVariantModel(mode: .reduced, action: .skip),
            RoutineModeVariantModel(mode: .expanded, action: .replace, replacementTitle: "Stretch Plus", replacementDurationSeconds: 1200)
        ]

        planDay.modeVariants = [
            RoutineModeVariantModel(mode: .reduced, action: .replace, replacementTitle: "Plan Essentials", replacementDurationSeconds: 300)
        ]

        template.tasks = [hydrate, stretch, planDay]
        hydrate.template = template
        stretch.template = template
        planDay.template = template

        return template
    }

    static func reducedPlanIsShorterThanBasic() -> Bool {
        let engine = RoutineScheduleEngine()
        let template = makeTemplate()
        let basic = engine.buildPlan(template: template, mode: .basic, for: .now)
        let reduced = engine.buildPlan(template: template, mode: .reduced, for: .now)
        return reduced.totalDurationSeconds < basic.totalDurationSeconds
    }

    static func stableSeedForSameDate() -> Bool {
        let engine = SleepFragmentParameterEngine()
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        return engine.stableSeed(for: date) == engine.stableSeed(for: date)
    }

    static func sampleSleepSummary(for date: Date) -> DailySleepSummaryData {
        let dayIndex = Calendar.current.component(.day, from: date)
        let variation = Double((dayIndex % 7) - 3)

        return DailySleepSummaryData(
            date: date,
            source: .sample,
            totalSleepMinutes: 430 + (variation * 12),
            awakeMinutes: max(8, 22 + variation * 3),
            wakeCount: max(0, 2 + Int(variation)),
            sleepEfficiency: 0.86 - (variation * 0.01),
            averageHeartRate: 58 + variation,
            hrvSDNN: 42 + (variation * 2),
            respiratoryRate: 14 + (variation * 0.2),
            stepCount: 420,
            dataQualityScore: 80
        )
    }

    static func sampleFragmentParameters(for date: Date) -> SleepFragmentParameters {
        let summary = sampleSleepSummary(for: date)
        let scoreEngine = SleepConditionScoreEngine()
        let score = scoreEngine.compute(
            input: SleepScoreInput(
                summary: summary,
                targetSleepMinutes: 450,
                morningPreparationScore: 72
            )
        )
        return SleepFragmentParameterEngine().makeParameters(
            from: score,
            totalSleepMinutes: summary.totalSleepMinutes,
            awakeMinutes: summary.awakeMinutes,
            wakeCount: summary.wakeCount,
            targetSleepMinutes: 450
        )
    }
}
