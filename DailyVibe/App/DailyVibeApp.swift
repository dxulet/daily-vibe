//  DailyVibeApp.swift
//  DailyVibe — App
//
//  @main entry. Phase 0 used ContentView() as the WindowGroup root;
//  Phase 1 swaps in RootRouter() which owns the single nav stack
//  + NavigationPath + sheet flags.
//
//  .preferredColorScheme(.dark) preserves SCAF-06 — dark mode is the
//  only supported mode.

import SwiftUI

@main
struct DailyVibeApp: App {
    var body: some Scene {
        WindowGroup {
            RootRouter()
                .preferredColorScheme(.dark)
        }
    }
}
