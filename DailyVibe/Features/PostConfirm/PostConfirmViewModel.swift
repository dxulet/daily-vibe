import Foundation

@Observable
@MainActor
final class PostConfirmViewModel {
    var isMatched: Bool = false
    private(set) var promptState: LoadState<DailyPrompt> = .idle
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
        promptState = .loading
        promptState = await resolveLoadState(
            toastCenter: toastCenter,
            errorMessage: "Couldn't load today's prompt."
        ) {
            try await repo.todayPrompt()
        }
    }
}
