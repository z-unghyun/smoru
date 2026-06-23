import Foundation

final class AppRouter: ObservableObject {
    @Published var currentRoute: AppRoute = .entry

    func route(to route: AppRoute) {
        currentRoute = route
    }
}
