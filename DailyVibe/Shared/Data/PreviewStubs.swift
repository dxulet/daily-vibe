#if DEBUG
import Foundation

struct StubFailingRepository: PostRepository {
    func feedPosts() async throws -> [Post] { throw PreviewError.network }
    func matchedPosts() async throws -> [Post] { throw PreviewError.network }
    func todayPrompt() async throws -> DailyPrompt { throw PreviewError.network }
    func matchedFriendsToday() async throws -> [Friend] { throw PreviewError.network }
}

struct StubSlowRepository: PostRepository {
    func feedPosts() async throws -> [Post] { try await stall(); return [] }
    func matchedPosts() async throws -> [Post] { try await stall(); return [] }
    func todayPrompt() async throws -> DailyPrompt { try await stall(); return MockDataProvider.todayPrompt }
    func matchedFriendsToday() async throws -> [Friend] { try await stall(); return [] }

    private func stall() async throws { try await Task.sleep(for: .seconds(60)) }
}

enum PreviewError: Error { case network }
#endif
