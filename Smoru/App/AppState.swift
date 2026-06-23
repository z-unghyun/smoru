import Foundation

final class AppState: ObservableObject {
    @Published var isTrialModeEnabled: Bool = false
    @Published var hasCompletedOnboarding: Bool = false
}
