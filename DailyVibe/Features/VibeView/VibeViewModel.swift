import Foundation

@Observable
@MainActor
final class VibeViewModel {
    private(set) var prompt: DailyPrompt = .placeholder
    private(set) var matchedPosts: [Post] = []
    private(set) var isLoading: Bool = false

    func load(repo: any PostRepository) async {
        isLoading = true
        defer { isLoading = false }

        async let delay: Void? = try? await Task.sleep(for: .milliseconds(200))
        async let prompt = try? repo.todayPrompt()
        async let matched = try? repo.matchedPosts()

        _ = await delay
        self.prompt = await prompt ?? .placeholder
        self.matchedPosts = await matched ?? []
    }
}
