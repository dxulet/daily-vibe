import Foundation

struct DailyPrompt: Hashable {
    let editionNumber: Int
    let promptText: String
    let date: Date
    let matchedFriendsCount: Int

    func overflowCount(visibleCount: Int) -> Int {
        max(0, matchedFriendsCount - visibleCount)
    }
}
