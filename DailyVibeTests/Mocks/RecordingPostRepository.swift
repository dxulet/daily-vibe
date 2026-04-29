import Foundation
@testable import DailyVibe

final class RecordingPostRepository: PostRepository, @unchecked Sendable {
    var feedPostsResult: [Post] = []
    var matchedPostsResult: [Post] = []
    var todayPromptResult: DailyPrompt = DailyPrompt(
        editionNumber: 1,
        promptText: "test",
        date: Date(timeIntervalSince1970: 0),
        matchedFriendsCount: 0
    )
    var matchedFriendsTodayResult: [Friend] = []

    var error: RepositoryError?

    private(set) var feedPostsCallCount = 0
    private(set) var todayPromptCallCount = 0
    private(set) var matchedPostsCallCount = 0
    private(set) var matchedFriendsTodayCallCount = 0

    func feedPosts() async throws -> [Post] {
        feedPostsCallCount += 1
        if let error { throw error }
        return feedPostsResult
    }

    func matchedPosts() async throws -> [Post] {
        matchedPostsCallCount += 1
        if let error { throw error }
        return matchedPostsResult
    }

    func todayPrompt() async throws -> DailyPrompt {
        todayPromptCallCount += 1
        if let error { throw error }
        return todayPromptResult
    }

    func matchedFriendsToday() async throws -> [Friend] {
        matchedFriendsTodayCallCount += 1
        if let error { throw error }
        return matchedFriendsTodayResult
    }
}
