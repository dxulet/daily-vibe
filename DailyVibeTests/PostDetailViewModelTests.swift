import Testing
import Foundation
@testable import DailyVibe

@MainActor
struct PostDetailViewModelTests {
    @Test("dwell event reports milliseconds between appear and disappear")
    func onDisappearReportsDwell() {
        let post = makePost()
        let vm = PostDetailViewModel(post: post)

        let appearedAt = Date(timeIntervalSince1970: 1_000_000)
        let disappearedAt = appearedAt.addingTimeInterval(2.5)

        vm.onAppear(now: appearedAt)
        let event = vm.onDisappear(now: disappearedAt)

        guard case let .dailyVibePostViewed(postId, dwellMs, surface) = event else {
            Issue.record("expected dailyVibePostViewed, got \(String(describing: event))")
            return
        }
        #expect(postId == post.id.uuidString)
        #expect(dwellMs == 2500)
        #expect(surface == "post_detail")
    }

    @Test("onDisappear without prior onAppear returns nil")
    func onDisappearWithoutAppearReturnsNil() {
        let vm = PostDetailViewModel(post: makePost())
        #expect(vm.onDisappear() == nil)
    }

    @Test("onDisappear consumes the appearance — second call returns nil")
    func dwellIsNotDoubleCounted() {
        let vm = PostDetailViewModel(post: makePost())
        vm.onAppear(now: Date(timeIntervalSince1970: 0))
        _ = vm.onDisappear(now: Date(timeIntervalSince1970: 1))

        #expect(vm.onDisappear() == nil)
    }

    private func makePost() -> Post {
        Post(
            id: UUID(),
            author: Friend(id: UUID(), username: "u", initials: "U", avatarPaletteIndex: 0),
            rearPhotoAsset: "r",
            selfiePhotoAsset: "s",
            timestampText: "now",
            isVibeMatched: false
        )
    }
}
