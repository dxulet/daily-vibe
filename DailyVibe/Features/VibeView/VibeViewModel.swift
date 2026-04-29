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

        async let prompt = repo.todayPrompt()
        async let matched = repo.matchedPosts()

        do {
            let snapshot = try await VibeSnapshot(prompt: prompt, matchedPosts: matched)
            state = .loaded(snapshot)
        } catch {
            state = .failed(error)
            toastCenter.show("Couldn't load today's vibe.")
        }
    }
}
