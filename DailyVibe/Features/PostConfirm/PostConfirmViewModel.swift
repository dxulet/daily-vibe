import Foundation

@Observable
@MainActor
final class PostConfirmViewModel {
    var isMatched: Bool = false

    private(set) var prompt: DailyPrompt = .placeholder

    func load(repo: any PostRepository) async {
        prompt = (try? await repo.todayPrompt()) ?? .placeholder
    }
}
