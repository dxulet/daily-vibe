import Foundation

enum MockDataProvider {
    static let friends: [Friend] = [
        Friend(id: UUID(), username: "marco", initials: "M", avatarPaletteIndex: 1),
        Friend(id: UUID(), username: "ayagul", initials: "A", avatarPaletteIndex: 2),
        Friend(id: UUID(), username: "daulet", initials: "D", avatarPaletteIndex: 3),
        Friend(id: UUID(), username: "sarah", initials: "S", avatarPaletteIndex: 4),
        Friend(id: UUID(), username: "jen", initials: "J", avatarPaletteIndex: 5),
    ]

    static let currentUser = Friend(
        id: UUID(),
        username: "you",
        initials: "Y",
        avatarPaletteIndex: 0
    )

    static let todayPrompt = DailyPrompt(
        editionNumber: 247,
        promptText: "your hands",
        date: Date(),
        matchedFriendsCount: 6
    )

    static let matchedFriendsToday: [Friend] = Array(friends.prefix(4))

    static let feedPosts: [Post] = [
        Post(id: UUID(), author: friends[0],
             rearPhotoAsset: "photo_1", selfiePhotoAsset: "selfie_1",
             timestampText: "now", isVibeMatched: false),
        Post(id: UUID(), author: friends[1],
             rearPhotoAsset: "photo_2", selfiePhotoAsset: "selfie_2",
             timestampText: "2h late", isVibeMatched: true),
        Post(id: UUID(), author: friends[2],
             rearPhotoAsset: "photo_3", selfiePhotoAsset: "selfie_3",
             timestampText: "5h late", isVibeMatched: false),
    ]

    static let matchedPosts: [Post] = (4...9).map { n in
        Post(
            id: UUID(),
            author: friends[n % friends.count],
            rearPhotoAsset: "photo_\(n)",
            selfiePhotoAsset: "selfie_\(n)",
            timestampText: "today",
            isVibeMatched: true
        )
    }
}
