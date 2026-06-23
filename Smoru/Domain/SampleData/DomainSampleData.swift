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
}
