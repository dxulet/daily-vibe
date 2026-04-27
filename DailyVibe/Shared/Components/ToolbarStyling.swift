//
//  ToolbarStyling.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

extension View {
    /// Applies the 3-modifier nav-bar stack: visible opaque dark background + dark color scheme.
    /// Call once on every PUSHED screen (PostConfirm, VibeView, PostDetail).
    /// Do NOT call on FeedScreen — it is the stack root and has no nav bar to style.
    /// (NAV-08 locked Phase 1; extension committed per CONTEXT.md.)
    func vibeToolbarStyling() -> some View {
        self
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.vibeBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
