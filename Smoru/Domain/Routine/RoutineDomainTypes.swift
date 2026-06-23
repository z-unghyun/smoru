import Foundation

struct ScheduledRoutineTask: Identifiable, Equatable {
    var id: UUID
    var orderIndex: Int
    var title: String
    var type: RoutineTaskType
    var durationSeconds: Int
    var startAt: Date
    var endAt: Date
    var launchURLString: String?
    var fallbackURLString: String?
    var appDisplayName: String?
}

struct TodayRoutinePlan: Equatable {
    var mode: RoutineMode
    var startAt: Date
    var endAt: Date
    var tasks: [ScheduledRoutineTask]

    var totalDurationSeconds: Int {
        tasks.reduce(0) { $0 + $1.durationSeconds }
    }
}

struct RoutineFocusState {
    var sessionId: UUID
    var mode: RoutineMode
    var tasks: [ScheduledRoutineTask]
    var currentIndex: Int
    var sessionState: RoutineSessionState
    var currentTaskStartedAt: Date?
    var currentTaskEndsAt: Date?
    var remainingSeconds: Int
    var elapsedSeconds: Int
    var isVoiceGuideEnabled: Bool
}
