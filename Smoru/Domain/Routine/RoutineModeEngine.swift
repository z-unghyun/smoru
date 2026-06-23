import Foundation

struct RoutineModeEngine {
    func selectMode(readinessScore: Double) -> RoutineMode {
        if readinessScore >= 80 {
            return .expanded
        }
        if readinessScore >= 55 {
            return .basic
        }
        return .reduced
    }
}
