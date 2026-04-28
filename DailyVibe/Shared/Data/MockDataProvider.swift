//
//  MockDataProvider.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

enum MockDataProvider {
    static let friends: [Friend] = [
        Friend(id: UUID(), username: "marco",   initials: "M", avatarColor: .red),
        Friend(id: UUID(), username: "aigerim", initials: "A", avatarColor: .teal),
        Friend(id: UUID(), username: "dulat",   initials: "D", avatarColor: .yellow),
        Friend(id: UUID(), username: "sarah",   initials: "S", avatarColor: .mint),
        Friend(id: UUID(), username: "jen",     initials: "J", avatarColor: .orange),
    ]

    // Synthetic current-user Friend for surfaces that render a "you" avatar
    // (e.g., FeedScreen's top-right profile circle). avatarColor is the muted
    // purple per Plan 03-01 decision (vibeAvatarMuted reserved for the user's chip).
    static let currentUser = Friend(
        id: UUID(),
        username: "you",
        initials: "Y",
        avatarColor: .vibeAvatarMuted
    )

    static var todayPrompt: DailyPrompt {
        DailyPrompt(
            editionNumber: 247,
            promptText: "your hands",
            date: Date(),
            matchedFriendsCount: 12
        )
    }

    static var matchedFriendsToday: [Friend] {
        Array(friends.prefix(4))
    }

    static var feedPosts: [Post] {
        [
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
    }

    static var matchedPosts: [Post] {
        (4...9).map { n in
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
}
