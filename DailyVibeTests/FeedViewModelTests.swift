import Testing
import Foundation
@testable import DailyVibe

@MainActor
struct FeedViewModelTests {
    @Test("idle → loaded on success")
    func loadIfNeededHappyPath() async {
        let repo = RecordingPostRepository()
        repo.feedPostsResult = [makePost()]
        repo.matchedFriendsTodayResult = [makeFriend()]

        let toast = ToastCenter()
        let vm = FeedViewModel(repo: repo, toastCenter: toast)

        #expect(vm.state.value == nil)

        await vm.loadIfNeeded()

        let snapshot = vm.state.value
        #expect(snapshot != nil)
        #expect(snapshot?.posts.count == 1)
        #expect(snapshot?.matchedFriends.count == 1)
        #expect(toast.current == nil)
    }

    @Test("idle → failed on repo error, with toast")
    func loadIfNeededFailurePath() async {
        let repo = RecordingPostRepository()
        repo.error = .offline

        let toast = ToastCenter()
        let vm = FeedViewModel(repo: repo, toastCenter: toast)

        await vm.loadIfNeeded()

        #expect(vm.state.error == .offline)
        #expect(toast.current?.kind == .error)
    }

    @Test("loadIfNeeded is idempotent — second call no-ops")
    func loadIfNeededIsIdempotent() async {
        let repo = RecordingPostRepository()
        repo.feedPostsResult = [makePost()]
        let vm = FeedViewModel(repo: repo, toastCenter: ToastCenter())

        await vm.loadIfNeeded()
        await vm.loadIfNeeded()

        #expect(repo.feedPostsCallCount == 1)
    }

    @Test("refresh re-fetches even after success")
    func refreshAlwaysFetches() async {
        let repo = RecordingPostRepository()
        let vm = FeedViewModel(repo: repo, toastCenter: ToastCenter())

        await vm.loadIfNeeded()
        await vm.refresh()

        #expect(repo.feedPostsCallCount == 2)
    }

    // MARK: - Fixtures

    private func makePost() -> Post {
        Post(
            id: UUID(),
            author: makeFriend(),
            rearPhotoAsset: "rear",
            selfiePhotoAsset: "selfie",
            timestampText: "now",
            isVibeMatched: false
        )
    }

    private func makeFriend() -> Friend {
        Friend(id: UUID(), username: "tester", initials: "T", avatarPaletteIndex: 0)
    }
}
