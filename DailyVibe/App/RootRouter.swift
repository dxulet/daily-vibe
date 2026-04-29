import SwiftUI

struct RootRouter: View {
    @Environment(\.router) private var router
    @Environment(\.toastCenter) private var toastCenter
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false

    var body: some View {
        @Bindable var router = router

        return NavigationStack(path: $router.path) {
            FeedScreen()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .postConfirm:
                        PostConfirmScreen()
                    case .vibeView:
                        VibeView()
                    case .postDetail(let post):
                        PostDetailScreen(post: post)
                    }
                }
        }
        .sheet(item: $router.sheet) { sheet in
            switch sheet {
            case .firstRun:
                FirstRunIntro()
                    .onDisappear { hasSeenIntro = true }
            case .settings:
                SettingsScreen()
            }
        }
        .toastHost(toastCenter)
        .task {
            if !hasSeenIntro { router.openFirstRun() }
        }
    }
}
