//  Typography.swift
//  DailyVibe — Shared/Theme
//
//  Named font tokens for the v1 type scale. Views reference these
//  via .font(.vibeWordmark) etc. and never inline Font.system(...) calls.
//  See FOUN-02. POLI-04 audit forbids the legacy weight modifier —
//  use .bold() at callsite if a one-off weight bump is needed.

import SwiftUI

extension Font {
    /// 24pt heavy — "BeReal." wordmark only (Phase 2 WordmarkHeader component)
    static let vibeWordmark = Font.system(size: 24, weight: .heavy)

    /// 15pt semibold — usernames, primary labels
    static let vibeUsername = Font.system(size: 15, weight: .semibold)

    /// 15pt regular — body copy
    static let vibeBody = Font.system(size: 15, weight: .regular)

    /// 13pt regular — "today's vibe", "no vibes yet" lowercase grey accents
    static let vibeAccentLowercase = Font.system(size: 13, weight: .regular)
}
