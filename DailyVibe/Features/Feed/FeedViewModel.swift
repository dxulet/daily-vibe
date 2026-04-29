import Foundation

struct FeedSnapshot: Sendable {
    var posts: [Post]
    var todayPrompt: DailyPrompt
    var matchedFriends: [Friend]
}

@Observable
@MainActor
final class FeedViewModel {
    private(set) var state: LoadState<FeedSnapshot> = .idle

    func load(repo: any PostRepository, toastCenter: ToastCenter) async {
        state = .loading

        async let posts = repo.feedPosts()
        async let prompt = repo.todayPrompt()
        async let matched = repo.matchedFriendsToday()

        do {
            let snapshot = try await FeedSnapshot(
                posts: posts,
                todayPrompt: prompt,
                matchedFriends: matched
            )
            state = .loaded(snapshot)
        } catch {
            state = .failed(error)
            toastCenter.show("Couldn't load your feed. Pull to refresh.")
        }
    }
}
