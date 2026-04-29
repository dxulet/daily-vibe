import Foundation

struct VibeSnapshot: Sendable {
    var prompt: DailyPrompt
    var matchedPosts: [Post]
}

@Observable
@MainActor
final class VibeViewModel {
    private(set) var state: LoadState<VibeSnapshot> = .idle
    private var repo: (any PostRepository)?
    private var toastCenter: ToastCenter?

    func load(repo: any PostRepository, toastCenter: ToastCenter) async {
        self.repo = repo
        self.toastCenter = toastCenter
        await reload()
    }

    func retry() async {
        await reload()
    }

    private func reload() async {
        guard let repo, let toastCenter else { return }
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
