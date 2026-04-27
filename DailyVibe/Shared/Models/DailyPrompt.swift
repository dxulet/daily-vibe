//  DailyPrompt.swift
//  DailyVibe — Shared/Models
//
//  The day's vibe prompt. Synthesized Hashable is correct here:
//  DailyPrompt is never a NavigationPath key (no Route case takes it as
//  associated value), and all fields are Hashable. Idempotency is moot.

import Foundation

struct DailyPrompt: Hashable {
    let editionNumber: Int
    let promptText: String
    let date: Date
    let matchedFriendsCount: Int
}
