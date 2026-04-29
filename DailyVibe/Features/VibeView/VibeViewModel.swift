import Foundation

struct VibeSnapshot: Sendable {
    var prompt: DailyPrompt
    var matchedPosts: [Post]
}

@Observable
@MainActor
final class VibeViewModel {
    private(set) var state: LoadState<VibeSnapshot> = .idle

    func load(repo: any PostRepository, toastCenter: ToastCenter) async {
        state = .loading
        state = await resolveLoadState(
            toastCenter: toastCenter,
            errorMessage: "Couldn't load today's vibe."
        ) {
            async let prompt = repo.todayPrompt()
            async let matched = repo.matchedPosts()
            return try await VibeSnapshot(prompt: prompt, matchedPosts: matched)
        }
    }
}
