import Foundation

struct RoutineScheduleEngine {
    func buildPlan(
        template: RoutineTemplateModel,
        mode: RoutineMode,
        for date: Date,
        calendar: Calendar = .current
    ) -> TodayRoutinePlan {
        let endAt = makeEndDate(for: date, hour: template.routineEndHour, minute: template.routineEndMinute, calendar: calendar)

        let sortedTasks = template.tasks.sorted { $0.orderIndex < $1.orderIndex }
        let plannedItems = sortedTasks.compactMap { task in
            resolveTaskPlan(task: task, mode: mode)
        }

        let totalDuration = plannedItems.reduce(0) { $0 + $1.duration }
        let startAt = endAt.addingTimeInterval(TimeInterval(-totalDuration))

        var cursor = startAt
        let scheduled = plannedItems.enumerated().map { index, item -> ScheduledRoutineTask in
            let start = cursor
            let end = start.addingTimeInterval(TimeInterval(item.duration))
            cursor = end

            return ScheduledRoutineTask(
                id: item.id,
                orderIndex: index,
                title: item.title,
                type: item.type,
                durationSeconds: item.duration,
                startAt: start,
                endAt: end,
                launchURLString: item.launchURLString,
                fallbackURLString: item.fallbackURLString,
                appDisplayName: item.appDisplayName
            )
        }

        return TodayRoutinePlan(mode: mode, startAt: startAt, endAt: endAt, tasks: scheduled)
    }

    private func makeEndDate(for date: Date, hour: Int, minute: Int, calendar: Calendar) -> Date {
        let base = calendar.startOfDay(for: date)
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: base) ?? date
    }

    private func resolveTaskPlan(task: RoutineTaskModel, mode: RoutineMode) -> (id: UUID, title: String, type: RoutineTaskType, duration: Int, launchURLString: String?, fallbackURLString: String?, appDisplayName: String?)? {
        let variant = task.modeVariants.first { $0.mode == mode }

        let action = variant?.action ?? .keep
        switch action {
        case .keep:
            return (task.id, task.title, task.type, max(task.durationSeconds, 0), task.launchURLString, task.fallbackURLString, task.appDisplayName)
        case .skip:
            return nil
        case .replace:
            let title = variant?.replacementTitle ?? task.title
            let duration = max(variant?.replacementDurationSeconds ?? task.durationSeconds, 0)
            return (task.id, title, task.type, duration, task.launchURLString, task.fallbackURLString, task.appDisplayName)
        }
    }
}
