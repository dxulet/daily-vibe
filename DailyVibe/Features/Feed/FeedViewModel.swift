import Foundation

@Observable
@MainActor
final class FeedViewModel {
    private(set) var posts: [Post] = []
    private(set) var todayPrompt: DailyPrompt = .placeholder
    private(set) var matchedFriends: [Friend] = []
    private(set) var isLoading: Bool = false

    func load(repo: any PostRepository) async {
        isLoading = true
        defer { isLoading = false }

        async let delay: Void? = try? await Task.sleep(for: .milliseconds(200))
        async let posts = try? repo.feedPosts()
        async let prompt = try? repo.todayPrompt()
        async let matched = try? repo.matchedFriendsToday()

        _ = await delay
        self.posts = await posts ?? []
        self.todayPrompt = await prompt ?? .placeholder
        self.matchedFriends = await matched ?? []
    }
}
