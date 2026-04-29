#if DEBUG
import SwiftUI

extension View {
    func previewEnvironments() -> some View {
        self
            .environment(\.router, AppRouter())
            .environment(\.postRepository, MockPostRepository())
            .environment(\.currentUserProvider, MockCurrentUserProvider())
            .environment(\.toastCenter, ToastCenter())
    }
}
#endif
