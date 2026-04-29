import Foundation
import SwiftUI

protocol PostRepository: Sendable {
    func feedPosts() async throws -> [Post]
    func matchedPosts() async throws -> [Post]
    func todayPrompt() async throws -> DailyPrompt
    func matchedFriendsToday() async throws -> [Friend]
}

protocol CurrentUserProvider: Sendable {
    var currentUser: Friend { get }
}

// Sentinel: missing injection crashes loudly instead of silently stubbing.
private struct UnconfiguredPostRepository: PostRepository {
    func feedPosts() async throws -> [Post] { fatalError("postRepository not injected") }
    func matchedPosts() async throws -> [Post] { fatalError("postRepository not injected") }
    func todayPrompt() async throws -> DailyPrompt { fatalError("postRepository not injected") }
    func matchedFriendsToday() async throws -> [Friend] { fatalError("postRepository not injected") }
}

private struct UnconfiguredCurrentUserProvider: CurrentUserProvider {
    var currentUser: Friend { fatalError("currentUserProvider not injected") }
}

extension EnvironmentValues {
    @Entry var postRepository: any PostRepository = UnconfiguredPostRepository()
    @Entry var currentUserProvider: any CurrentUserProvider = UnconfiguredCurrentUserProvider()
}
