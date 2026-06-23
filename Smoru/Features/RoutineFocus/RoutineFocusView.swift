import SwiftUI
import SwiftData
import AVFoundation

struct RoutineFocusView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appRouter: AppRouter

    @Query(sort: [SortDescriptor(\RoutineTemplateModel.createdAt, order: .forward)])
    private var templates: [RoutineTemplateModel]

    @State private var focusState: RoutineFocusState?
    @State private var sessionEngine = RoutineSessionEngine()
    @State private var previousTaskIndex: Int = -1

    private let scheduleEngine = RoutineScheduleEngine()
    private let voiceGuide = RoutineVoiceGuide()
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            immersiveBackground
                .ignoresSafeArea()

            if let state = focusState, let currentTask = currentTask(from: state) {
                VStack {
                    HStack {
                        Button {
                            exitRoutine()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 28, height: 28)
                                .background(.black.opacity(0.45))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.leading, 18)
                    .padding(.top, 12)

                    Spacer()

                    Text(currentTask.title)
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 26)

                    Text(timeString(seconds: state.remainingSeconds))
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.top, 8)

                    Button {
                        togglePauseResume()
                    } label: {
                        Text(state.sessionState == .paused ? "Resume" : "Pause")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(width: 180, height: 180)
                            .background(Circle().fill(Color.black.opacity(0.32)))
                            .overlay(Circle().stroke(.white.opacity(0.35), lineWidth: 2))
                    }
                    .padding(.top, 22)

                    Spacer()
                }

                HStack {
                    nextTaskPreview(state: state)
                        .padding(.leading, 12)
                    Spacer()
                }
                .padding(.top, 120)
            } else {
                VStack(spacing: 16) {
                    Text("Routine Focus")
                        .font(.title2.weight(.semibold))
                    Text("No routine plan available. Create a routine first.")
                        .foregroundStyle(.secondary)
                    PrimaryButton(title: "Back Home") {
                        appRouter.route(to: .home)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .onAppear {
            startIfNeeded()
        }
        .onReceive(ticker) { now in
            guard var state = focusState else { return }
            sessionEngine.tick(state: &state, now: now)
            observeTaskChange(state)

            if state.sessionState == .completed {
                focusState = state
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    appRouter.route(to: .home)
                }
                return
            }

            focusState = state
        }
    }

    private var immersiveBackground: some View {
        let colors: [Color]
        switch appState.focusMode {
        case .expanded:
            colors = [.indigo, .mint]
        case .basic:
            colors = [.blue, .purple]
        case .reduced:
            colors = [.teal, .gray]
        }

        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    @ViewBuilder
    private func nextTaskPreview(state: RoutineFocusState) -> some View {
        if let next = nextTask(from: state) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Next")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                Text(next.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("\(next.durationSeconds / 60)m")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(10)
            .background(.black.opacity(0.28))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    private func startIfNeeded() {
        guard focusState == nil else { return }

        let template = selectedTemplate ?? DomainSampleData.makeTemplate()
        let plan = scheduleEngine.buildPlan(template: template, mode: appState.focusMode, for: .now)

        if plan.tasks.isEmpty {
            focusState = nil
            return
        }

        focusState = sessionEngine.startSession(plan: plan, isVoiceGuideEnabled: template.voiceGuideEnabled, now: .now)
        previousTaskIndex = focusState?.currentIndex ?? -1
        if template.voiceGuideEnabled, let current = focusState.flatMap({ currentTask(from: $0) }) {
            voiceGuide.speak(taskTitle: current.title)
        }
    }

    private var selectedTemplate: RoutineTemplateModel? {
        if let selectedID = appState.selectedRoutineTemplateID {
            return templates.first { $0.id == selectedID }
        }
        return templates.first
    }

    private func currentTask(from state: RoutineFocusState) -> ScheduledRoutineTask? {
        guard state.currentIndex >= 0, state.currentIndex < state.tasks.count else {
            return nil
        }
        return state.tasks[state.currentIndex]
    }

    private func nextTask(from state: RoutineFocusState) -> ScheduledRoutineTask? {
        let nextIndex = state.currentIndex + 1
        guard nextIndex >= 0, nextIndex < state.tasks.count else {
            return nil
        }
        return state.tasks[nextIndex]
    }

    private func togglePauseResume() {
        guard var state = focusState else { return }
        if state.sessionState == .running {
            sessionEngine.pauseSession(state: &state)
        } else if state.sessionState == .paused {
            sessionEngine.resumeSession(state: &state, now: .now)
        }
        focusState = state
    }

    private func exitRoutine() {
        guard var state = focusState else {
            appRouter.route(to: .home)
            return
        }
        sessionEngine.exitSession(state: &state)
        focusState = state
        appRouter.route(to: .home)
    }

    private func observeTaskChange(_ state: RoutineFocusState) {
        guard state.currentIndex != previousTaskIndex else { return }
        previousTaskIndex = state.currentIndex

        guard state.isVoiceGuideEnabled, let task = currentTask(from: state) else {
            return
        }
        voiceGuide.speak(taskTitle: task.title)
    }

    private func timeString(seconds: Int) -> String {
        let minutes = max(seconds, 0) / 60
        let remainder = max(seconds, 0) % 60
        return String(format: "%02d:%02d", minutes, remainder)
    }
}

private final class RoutineVoiceGuide {
    private let synth = AVSpeechSynthesizer()

    func speak(taskTitle: String) {
        let utterance = AVSpeechUtterance(string: taskTitle)
        utterance.rate = 0.48
        synth.speak(utterance)
    }
}
