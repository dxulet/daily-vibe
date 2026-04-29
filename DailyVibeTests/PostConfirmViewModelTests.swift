import Testing
import Foundation
@testable import DailyVibe

@MainActor
struct PostConfirmViewModelTests {
    @Test("canPublish is false until prompt loads")
    func canPublishIsFalseWhenIdle() {
        let vm = makeVM()
        #expect(vm.canPublish == false)
    }

    @Test("canPublish becomes true after prompt loads")
    func canPublishIsTrueAfterLoad() async {
        let vm = makeVM()
        await vm.loadIfNeeded()
        #expect(vm.canPublish == true)
    }

    @Test("canPublish is false on load failure")
    func canPublishIsFalseOnFailure() async {
        let repo = RecordingPostRepository()
        repo.error = .timedOut
        let vm = PostConfirmViewModel(repo: repo, toastCenter: ToastCenter())

        await vm.loadIfNeeded()

        #expect(vm.canPublish == false)
    }

    @Test("publish returns the loaded prompt")
    func publishReturnsPrompt() async {
        let vm = makeVM()
        await vm.loadIfNeeded()

        let prompt = await vm.publish()

        #expect(prompt?.editionNumber == 42)
    }

    @Test("publish returns nil when prompt is not loaded")
    func publishGuardsAgainstUnloadedState() async {
        let vm = makeVM()
        let prompt = await vm.publish()
        #expect(prompt == nil)
    }

    private func makeVM() -> PostConfirmViewModel {
        let repo = RecordingPostRepository()
        repo.todayPromptResult = DailyPrompt(
            editionNumber: 42,
            promptText: "your hands",
            date: Date(timeIntervalSince1970: 0),
            matchedFriendsCount: 3
        )
        return PostConfirmViewModel(repo: repo, toastCenter: ToastCenter())
    }
}
