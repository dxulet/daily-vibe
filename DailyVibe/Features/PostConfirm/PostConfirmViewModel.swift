import Foundation

@Observable
@MainActor
final class PostConfirmViewModel {
    var isMatched: Bool = false
    private(set) var promptState: LoadState<DailyPrompt> = .idle

    func load(repo: any PostRepository, toastCenter: ToastCenter) async {
        promptState = .loading
        do {
            let prompt = try await repo.todayPrompt()
            promptState = .loaded(prompt)
        } catch {
            promptState = .failed(error)
            toastCenter.show("Couldn't load today's prompt.")
        }
    }
}
