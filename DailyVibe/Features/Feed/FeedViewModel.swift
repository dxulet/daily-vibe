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
        if let resolved { state = resolved }
    }
}
