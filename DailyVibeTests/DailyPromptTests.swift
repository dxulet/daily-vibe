import Testing
import Foundation
@testable import DailyVibe

struct DailyPromptTests {
    @Test("overflowCount returns positive remainder")
    func overflowCountWhenOver() {
        let prompt = makePrompt(matched: 10)
        #expect(prompt.overflowCount(visibleCount: 4) == 6)
    }

    @Test("overflowCount clamps to zero when visible exceeds matched")
    func overflowCountClampsToZero() {
        let prompt = makePrompt(matched: 2)
        #expect(prompt.overflowCount(visibleCount: 4) == 0)
    }

    @Test("overflowCount is zero when exactly equal")
    func overflowCountIsZeroAtBoundary() {
        let prompt = makePrompt(matched: 4)
        #expect(prompt.overflowCount(visibleCount: 4) == 0)
    }

    @Test("promptId encodes the edition number")
    func promptIdFormat() {
        #expect(makePrompt(matched: 0).promptId == "vibe_247")
    }

    private func makePrompt(matched: Int) -> DailyPrompt {
        DailyPrompt(
            editionNumber: 247,
            promptText: "your hands",
            date: Date(timeIntervalSince1970: 0),
            matchedFriendsCount: matched
        )
    }
}
