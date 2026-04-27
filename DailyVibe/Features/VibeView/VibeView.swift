//  VibeView.swift
//  DailyVibe — Features/VibeView
//
//  Phase 1 placeholder. Phase 3 grows this into the real VibeView
//  (prompt card + LazyVGrid of 6 matched DualCameraPhoto cells).

import SwiftUI

struct VibeView: View {
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()
            VStack(spacing: 8) {
                Text("VibeView")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("placeholder")
                    .font(.vibeAccentLowercase)
                    .foregroundStyle(Color.vibeSecondaryText)

                // Demo: push a postDetail to confirm Route.postDetail(Post)
                // fires correctly with id-only Hashable. Phase 3 replaces
                // this with grid-cell taps.
                Button("push postDetail (matched post)") {
                    path.append(Route.postDetail(MockDataProvider.matchedPosts[0]))
                }
                .font(.vibeBody)
                .foregroundStyle(Color.vibeAccent)
                .padding(.top, 16)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
