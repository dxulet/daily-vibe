//  Colors.swift
//  DailyVibe — Shared/Theme
//
//  Single source of truth for all raw hex tokens in the app.
//  Views must reference these by name (Color.vibeBackground, etc.) and
//  NEVER inline Color(red:green:blue:) or hex string literals.
//  See FOUN-01 + Roadmap Success Criterion 5.

import SwiftUI

extension Color {
    /// #000000 — pure black, app background
    static let vibeBackground = Color(red: 0.0, green: 0.0, blue: 0.0)

    /// #1C1C1E — primary surface (cards, strip)
    static let vibeSurface = Color(red: 28/255, green: 28/255, blue: 30/255)

    /// #2C2C2E — elevated surface
    static let vibeSurfaceElevated = Color(red: 44/255, green: 44/255, blue: 46/255)

    /// #8E8E93 — secondary text (timestamps, lowercase accents)
    static let vibeSecondaryText = Color(red: 142/255, green: 142/255, blue: 147/255)

    /// #FFCC4D — yellow accent (✦ marker, today's vibe glyph)
    static let vibeAccent = Color(red: 255/255, green: 204/255, blue: 77/255)

    /// #FF3B30 — destructive (declared for completeness; unused in v1)
    static let vibeDestructive = Color(red: 255/255, green: 59/255, blue: 48/255)
}
