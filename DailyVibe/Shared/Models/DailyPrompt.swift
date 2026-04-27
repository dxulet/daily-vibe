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
}
