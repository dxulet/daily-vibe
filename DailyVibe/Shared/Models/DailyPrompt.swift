//
//  DailyPrompt.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import Foundation

struct DailyPrompt: Hashable {
    let editionNumber: Int
    let promptText: String
    let date: Date
    let matchedFriendsCount: Int

    /// Number of matched friends not represented in a face-pile of `visibleCount` avatars.
    /// Used by DailyVibeStrip to render the "+N" overflow chip.
    func overflowCount(visibleCount: Int) -> Int {
        max(0, matchedFriendsCount - visibleCount)
    }
}
