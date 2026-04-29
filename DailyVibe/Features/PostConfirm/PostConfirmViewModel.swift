import Foundation

@Observable
@MainActor
final class PostConfirmViewModel {
    var isMatched: Bool = false
    private(set) var promptState: LoadState<DailyPrompt> = .idle

    func load(repo: any PostRepository, toastCenter: ToastCenter) async {
        promptState = .loading
        promptState = await resolveLoadState(
            toastCenter: toastCenter,
            errorMessage: "Couldn't load today's prompt."
        ) {
            try await repo.todayPrompt()
        }
    }
}
