#if DEBUG
import Foundation

struct StubFailingRepository: PostRepository {
    let error: RepositoryError

    init(error: RepositoryError = .offline) {
        self.error = error
    }

    func feedPosts() async throws -> [Post] { throw error }
    func matchedPosts() async throws -> [Post] { throw error }
    func todayPrompt() async throws -> DailyPrompt { throw error }
    func matchedFriendsToday() async throws -> [Friend] { throw error }
}

struct StubSlowRepository: PostRepository {
    func feedPosts() async throws -> [Post] { try await stall(); return [] }
    func matchedPosts() async throws -> [Post] { try await stall(); return [] }
    func todayPrompt() async throws -> DailyPrompt { try await stall(); return MockDataProvider.todayPrompt }
    func matchedFriendsToday() async throws -> [Friend] { try await stall(); return [] }

    private func stall() async throws { try await Task.sleep(for: .seconds(60)) }
}
#endif
