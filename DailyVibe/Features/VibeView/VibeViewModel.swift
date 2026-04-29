import Foundation

struct VibeSnapshot: Sendable {
    var prompt: DailyPrompt
    var matchedPosts: [Post]
}

@Observable
@MainActor
final class VibeViewModel {
    private(set) var state: LoadState<VibeSnapshot> = .idle

    var prompt: DailyPrompt? { state.value?.prompt }

    private let repo: any PostRepository
    private let toastCenter: ToastCenter

    init(repo: any PostRepository, toastCenter: ToastCenter) {
        self.repo = repo
        self.toastCenter = toastCenter
    }

    func loadIfNeeded() async {
        if case .idle = state {
            await fetch()
        }
    }

    func refresh() async {
        await fetch()
    }

    private func fetch() async {
        state = .loading
        let resolved = await resolveLoadState(
            toastCenter: toastCenter,
            errorMessage: "Couldn't load today's vibe."
        ) {
            async let prompt = repo.todayPrompt()
            async let matched = repo.matchedPosts()
            return try await VibeSnapshot(prompt: prompt, matchedPosts: matched)
        }
        if let resolved { state = resolved }
    }
}
