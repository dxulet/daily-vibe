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

    // nonisolated so the @Entry default below can build off the main actor.
    nonisolated init() {}

    func push(_ route: Route) { path.append(route) }
    func pop() { _ = path.popLast() }
}

extension EnvironmentValues {
    @Entry var router: AppRouter = AppRouter()
}
