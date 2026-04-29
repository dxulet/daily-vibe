import Foundation

@Observable
@MainActor
final class PostDetailViewModel {
    let post: Post
    private var appearedAt: Date?

    init(post: Post) {
        self.post = post
    }

    func onAppear(now: Date = .now) {
        appearedAt = now
    }

    func onDisappear(now: Date = .now) -> AnalyticsEvent? {
        guard let appearedAt else { return nil }
        let dwellMs = Int(now.timeIntervalSince(appearedAt) * 1000)
        self.appearedAt = nil
        return .dailyVibePostViewed(
            postId: post.id.uuidString,
            dwellMs: dwellMs,
            surface: "post_detail"
        )
    }

    func reactionEvent() -> AnalyticsEvent {
        .dailyVibeReactionAdded(
            postId: post.id.uuidString,
            reactionType: "realmoji",
            surface: "post_detail"
        )
    }
}
