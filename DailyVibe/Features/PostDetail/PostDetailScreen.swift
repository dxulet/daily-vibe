//  PostDetailScreen.swift
//  DailyVibe — Features/PostDetail
//
//  Phase 1 placeholder. Receives Post directly (no ViewModel — DETL-01).
//  Phase 3 grows this into the real PostDetail (DualCameraPhoto with
//  marker + "✦ today's vibe" chip + caption + 3 RealMoji circles +
//  "0 comments").

import SwiftUI

struct PostDetailScreen: View {
    let post: Post

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()
            VStack(spacing: 8) {
                Text("PostDetail")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("@\(post.author.username) — \(post.timestampText)")
                    .font(.vibeAccentLowercase)
                    .foregroundStyle(Color.vibeSecondaryText)
                Text(post.isVibeMatched ? "matched" : "not matched")
                    .font(.vibeBody)
                    .foregroundStyle(post.isVibeMatched ? Color.vibeAccent : Color.vibeSecondaryText)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
