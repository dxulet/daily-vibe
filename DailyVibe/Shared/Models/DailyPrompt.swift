import Foundation

struct DailyPrompt: Hashable {
    let editionNumber: Int
    let promptText: String
    let date: Date
    let matchedFriendsCount: Int

    var promptId: String { "vibe_\(editionNumber)" }

    func overflowCount(visibleCount: Int) -> Int {
        max(0, matchedFriendsCount - visibleCount)
    }
}
