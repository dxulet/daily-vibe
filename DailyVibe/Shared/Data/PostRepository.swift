import Foundation

protocol PostRepository: Sendable {
    func feedPosts() async throws -> [Post]
    func matchedPosts() async throws -> [Post]
    func todayPrompt() async throws -> DailyPrompt
    func matchedFriendsToday() async throws -> [Friend]
}

protocol CurrentUserProvider: Sendable {
    var currentUser: Friend { get }
}
