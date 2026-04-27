//
//  PostDetailScreen.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

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
