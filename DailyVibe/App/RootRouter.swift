//
//  RootRouter.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

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
