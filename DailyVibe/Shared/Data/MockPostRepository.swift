import Foundation

struct MockPostRepository: PostRepository {
    func feedPosts() async throws -> [Post] {
        MockDataProvider.feedPosts
    }

    func matchedPosts() async throws -> [Post] {
        MockDataProvider.matchedPosts
    }

    func todayPrompt() async throws -> DailyPrompt {
        MockDataProvider.todayPrompt
    }

    func matchedFriendsToday() async throws -> [Friend] {
        MockDataProvider.matchedFriendsToday
    }
}

struct MockCurrentUserProvider: CurrentUserProvider {
    var currentUser: Friend { MockDataProvider.currentUser }
}
