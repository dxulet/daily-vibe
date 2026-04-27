//  RootRouter.swift
//  DailyVibe — App
//
//  The single NavigationStack owner. NAV-01..NAV-08 land here.
//
//  Owns:
//    - @State path = NavigationPath()         (NAV-02)
//    - @State showFirstRun = true             (NAV-02 + NAV-05)
//    - @State showSettings = false            (NAV-02)
//
//  Wires:
//    - Stack root: FeedScreen(path: $path, onProfileTap: { showSettings = true })
//    - .navigationDestination(for: Route.self) { route in switch route { ... } }
//      covering all 4 cases (.feed, .postConfirm, .vibeView, .postDetail(Post))
//    - .sheet(isPresented: $showFirstRun) { FirstRunIntro() }
//    - .sheet(isPresented: $showSettings) { SettingsScreen() }
//
//  Per CONTEXT.md "RootRouter wiring": NO @ViewBuilder helper extraction
//  for the destination switch — one file owns nav.

import SwiftUI

struct RootRouter: View {
    @State private var path = NavigationPath()

    // PROTOTYPE: production version gates on @AppStorage("hasSeenIntro")
    @State private var showFirstRun = true

    @State private var showSettings = false

    var body: some View {
        NavigationStack(path: $path) {
            FeedScreen(
                path: $path,
                onProfileTap: { showSettings = true }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .feed:
                    FeedScreen(
                        path: $path,
                        onProfileTap: { showSettings = true }
                    )
                case .postConfirm:
                    PostConfirmScreen(path: $path)
                case .vibeView:
                    VibeView(path: $path)
                case .postDetail(let post):
                    PostDetailScreen(post: post)
                }
            }
        }
        .sheet(isPresented: $showFirstRun) { FirstRunIntro() }
        .sheet(isPresented: $showSettings) { SettingsScreen() }
    }
}
