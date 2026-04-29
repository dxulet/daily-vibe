import SwiftUI

@Observable
@MainActor
final class AppRouter {
    enum Sheet: Identifiable {
        case firstRun
        case settings
        var id: Self { self }
    }

    var path: [Route] = []
    var sheet: Sheet?

    // nonisolated so the @Entry default in EnvironmentValues can build one
    // synchronously off the main actor.
    nonisolated init() {}

    func push(_ route: Route) { path.append(route) }
    func pop() { _ = path.popLast() }

    func openSettings() { sheet = .settings }
    func openFirstRun() { sheet = .firstRun }
}

extension EnvironmentValues {
    @Entry var router: AppRouter = AppRouter()
}
