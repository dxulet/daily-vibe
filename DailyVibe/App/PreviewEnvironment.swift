#if DEBUG
import SwiftUI

extension View {
    /// Injects mock implementations of every app-level dependency so that
    /// SwiftUI Previews see a fully-wired environment. Without this, previews
    /// for screens that read `@Environment(\.router)` or `\.postRepository`
    /// silently bind to the (no-op) `@Entry` default and navigation buttons
    /// appear broken.
    func previewEnvironments() -> some View {
        self
            .environment(\.router, AppRouter())
            .environment(\.postRepository, MockPostRepository())
            .environment(\.currentUserProvider, MockCurrentUserProvider())
            .environment(\.toastCenter, ToastCenter())
    }
}
#endif
