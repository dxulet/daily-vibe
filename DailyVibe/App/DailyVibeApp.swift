import SwiftUI

@main
struct DailyVibeApp: App {
    @State private var router = AppRouter()
    @State private var toastCenter = ToastCenter()
    private let postRepository: any PostRepository = MockPostRepository()
    private let currentUserProvider: any CurrentUserProvider = MockCurrentUserProvider()
    private let analytics: any AnalyticsLogger = {
        #if DEBUG
        return ConsoleAnalyticsLogger()
        #else
        return NoopAnalyticsLogger()
        #endif
    }()

    var body: some Scene {
        WindowGroup {
            RootRouter()
                .installAppEnvironment(
                    router: router,
                    toastCenter: toastCenter,
                    postRepository: postRepository,
                    currentUserProvider: currentUserProvider,
                    analytics: analytics
                )
                .preferredColorScheme(.dark)
        }
    }
}
