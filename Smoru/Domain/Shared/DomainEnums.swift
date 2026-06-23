import Foundation

enum RoutineMode: String, Codable, CaseIterable, Identifiable {
    case expanded
    case basic
    case reduced

    var id: String { rawValue }
}

enum RoutineTaskType: String, Codable, CaseIterable, Identifiable {
    case basic
    case alarmLike
    case multiTimer
    case appOpen
    case linkOpen

    var id: String { rawValue }
}

enum RoutineTaskModeAction: String, Codable, CaseIterable, Identifiable {
    case keep
    case replace
    case skip

    var id: String { rawValue }
}

enum SleepDataSource: String, Codable, CaseIterable, Identifiable {
    case healthKit
    case manual
    case sample

    var id: String { rawValue }
}

enum RoutineSessionState: String, Codable, CaseIterable, Identifiable {
    case scheduled
    case running
    case paused
    case completed
    case exited

    var id: String { rawValue }
}

enum RoutineTaskProgressState: String, Codable, CaseIterable, Identifiable {
    case pending
    case completed
    case skipped

    var id: String { rawValue }
}
