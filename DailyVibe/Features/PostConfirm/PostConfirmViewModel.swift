import Foundation

@Observable
@MainActor
final class PostConfirmViewModel {
    var isMatched: Bool = false
    private(set) var promptState: LoadState<DailyPrompt> = .idle
    private(set) var isPublishing: Bool = false

    private let repo: any PostRepository
    private let toastCenter: ToastCenter

    init(repo: any PostRepository, toastCenter: ToastCenter) {
        self.repo = repo
        self.toastCenter = toastCenter
    }

    var canPublish: Bool {
        if case .loaded = promptState, !isPublishing { return true }
        return false
    }

    func loadIfNeeded() async {
        if case .idle = promptState {
            await fetchPrompt()
        }
    }

    func refresh() async {
        await fetchPrompt()
    }

    func publish() async -> DailyPrompt? {
        guard case .loaded(let prompt) = promptState, !isPublishing else { return nil }
        isPublishing = true
        defer { isPublishing = false }
        return prompt
    }

    private func fetchPrompt() async {
        promptState = .loading
        let resolved = await resolveLoadState(
            toastCenter: toastCenter,
            errorMessage: "Couldn't load today's prompt."
        ) {
            try await repo.todayPrompt()
        }
        if let resolved { promptState = resolved }
    }
}
