//  MockDataProvider.swift
//  DailyVibe — Shared/Data
//
//  Single source of all hardcoded mock data for the v1 prototype.
//
//  Type is `enum` (caseless namespace) — NOT a struct, class, or actor.
//  - struct: instantiable; namespace ceremony
//  - final class: instantiable + ceremony
//  - actor: forces isolation hop with zero benefit (called only from @MainActor VMs in Phase 2)
//  See FOUN-07 + FOUN-11.
//
//  `friends` is a `static let` (immutable identity).
//  `todayPrompt` is a `static var` so Date() re-evaluates per access (FOUN-07).
//  Mock model types (Friend, Post, DailyPrompt) carry no concurrency-conformance
//  annotations — same-actor access from @MainActor ViewModels; never crosses
//  isolation boundary. See FOUN-11.

import SwiftUI

enum MockDataProvider {
    // MARK: - Friends (5 total; 4 visible in face-pile via prefix(4))

    static let friends: [Friend] = [
        Friend(id: UUID(), username: "marco",   initials: "M", avatarColor: .red),
        Friend(id: UUID(), username: "aigerim", initials: "A", avatarColor: .teal),
        Friend(id: UUID(), username: "dulat",   initials: "D", avatarColor: .yellow),
        Friend(id: UUID(), username: "sarah",   initials: "S", avatarColor: .mint),
        Friend(id: UUID(), username: "jen",     initials: "J", avatarColor: .orange),
    ]

    // MARK: - Today's prompt (recomputed per access — Date() re-evaluates)

    /// `static var` (computed) — re-evaluates Date() per access (FOUN-07).
    /// matchedFriendsCount == 12 reconciles with matchedFriendsToday.count == 4
    /// for the strip's "+8 more" math.
    static var todayPrompt: DailyPrompt {
        DailyPrompt(
            editionNumber: 247,
            promptText: "your hands",
            date: Date(),
            matchedFriendsCount: 12
        )
    }

    // MARK: - Matched-friends face-pile (exactly 4 visible)

    /// 4 visible avatars; "+N more" computed as todayPrompt.matchedFriendsCount - count == 12 - 4 == 8.
    static var matchedFriendsToday: [Friend] {
        Array(friends.prefix(4))
    }

    // MARK: - Feed (exactly 3 posts; exactly 1 matched — FOUN-09)

    /// 3 feed posts; index 1 is the matched one (middle card has the marker).
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

    // MARK: - Vibe grid (exactly 6 posts; all matched — FOUN-10)

    /// 6 matched posts using photo_4..photo_9 + selfie_4..selfie_9.
    /// Author cycles through friends[] modulo length for variety.
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
