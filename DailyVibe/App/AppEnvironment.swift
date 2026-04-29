import SwiftUI

extension View {
    func installAppEnvironment(
        router: AppRouter,
        toastCenter: ToastCenter,
        postRepository: any PostRepository,
        currentUserProvider: any CurrentUserProvider,
        analytics: any AnalyticsLogger
    ) -> some View {
        self
            .environment(\.router, router)
            .environment(\.toastCenter, toastCenter)
            .environment(\.postRepository, postRepository)
            .environment(\.currentUserProvider, currentUserProvider)
            .environment(\.analytics, analytics)
    }
}
