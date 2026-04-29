import SwiftUI

@main
struct DailyVibeApp: App {
    @State private var router = AppRouter()
    private let postRepository: any PostRepository = MockPostRepository()
    private let currentUserProvider: any CurrentUserProvider = MockCurrentUserProvider()

    var body: some Scene {
        WindowGroup {
            RootRouter()
                .environment(\.router, router)
                .environment(\.postRepository, postRepository)
                .environment(\.currentUserProvider, currentUserProvider)
                .preferredColorScheme(.dark)
        }
    }
}
