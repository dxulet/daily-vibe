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
        state = await resolveLoadState(
            toastCenter: toastCenter,
            errorMessage: "Couldn't load your feed. Pull to refresh."
        ) {
            async let posts = repo.feedPosts()
            async let prompt = repo.todayPrompt()
            async let matched = repo.matchedFriendsToday()
            return try await FeedSnapshot(
                posts: posts,
                todayPrompt: prompt,
                matchedFriends: matched
            )
        }
    }
}
