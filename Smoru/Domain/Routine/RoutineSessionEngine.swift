import Foundation

struct RoutineSessionEngine {
    func startSession(plan: TodayRoutinePlan, isVoiceGuideEnabled: Bool, now: Date = .now) -> RoutineFocusState {
        let currentTask = plan.tasks.first
        return RoutineFocusState(
            sessionId: UUID(),
            mode: plan.mode,
            tasks: plan.tasks,
            currentIndex: 0,
            sessionState: .running,
            currentTaskStartedAt: now,
            currentTaskEndsAt: currentTask.map { now.addingTimeInterval(TimeInterval($0.durationSeconds)) },
            remainingSeconds: currentTask?.durationSeconds ?? 0,
            elapsedSeconds: 0,
            isVoiceGuideEnabled: isVoiceGuideEnabled
        )
    }

    mutating func pauseSession(state: inout RoutineFocusState) {
        guard state.sessionState == .running else { return }
        state.sessionState = .paused
    }

    mutating func resumeSession(state: inout RoutineFocusState, now: Date = .now) {
        guard state.sessionState == .paused else { return }
        state.sessionState = .running
        state.currentTaskStartedAt = now
        state.currentTaskEndsAt = now.addingTimeInterval(TimeInterval(max(state.remainingSeconds, 0)))
    }

    mutating func exitSession(state: inout RoutineFocusState) {
        state.sessionState = .exited
        state.currentTaskEndsAt = nil
    }

    mutating func advanceToNextTaskAutomatically(state: inout RoutineFocusState, now: Date = .now) {
        let nextIndex = state.currentIndex + 1
        guard nextIndex < state.tasks.count else {
            state.sessionState = .completed
            state.currentTaskEndsAt = nil
            state.remainingSeconds = 0
            return
        }

        state.currentIndex = nextIndex
        state.currentTaskStartedAt = now
        let nextDuration = state.tasks[nextIndex].durationSeconds
        state.currentTaskEndsAt = now.addingTimeInterval(TimeInterval(nextDuration))
        state.remainingSeconds = max(nextDuration, 0)
    }

    mutating func handleTaskTimeEnded(state: inout RoutineFocusState, now: Date = .now) {
        guard state.sessionState == .running else { return }
        guard let currentTaskEndsAt = state.currentTaskEndsAt else { return }
        guard now >= currentTaskEndsAt else { return }
        advanceToNextTaskAutomatically(state: &state, now: now)
    }

    mutating func tick(state: inout RoutineFocusState, now: Date = .now) {
        guard state.sessionState == .running else { return }
        guard let currentTaskEndsAt = state.currentTaskEndsAt else { return }

        let remaining = max(Int(currentTaskEndsAt.timeIntervalSince(now).rounded(.down)), 0)
        state.remainingSeconds = remaining
        state.elapsedSeconds += 1

        if remaining == 0 {
            advanceToNextTaskAutomatically(state: &state, now: now)
        }
    }
}
