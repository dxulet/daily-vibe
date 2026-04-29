#if DEBUG
import SwiftUI

extension View {
    func previewEnvironments() -> some View {
        installAppEnvironment(
            router: AppRouter(),
            toastCenter: ToastCenter(),
            postRepository: MockPostRepository(),
            currentUserProvider: MockCurrentUserProvider(),
            analytics: NoopAnalyticsLogger()
        )
    }
}
#endif
