//
//  PostCard.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct PostCard: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            UsernameRow(author: post.author, timestampText: post.timestampText)
            DualCameraPhoto(
                rearAsset: post.rearPhotoAsset,
                selfieAsset: post.selfiePhotoAsset,
                showMarker: post.isVibeMatched
            )
            .aspectRatio(3/4, contentMode: .fit)
        }
    }
}

// Private helper — internal to PostCard.swift. The two callers (Feed, PostDetail in Phase 3)
// don't compose this independently, so it stays out of the public Shared/Components/ surface.
private struct UsernameRow: View {
    let author: Friend
    let timestampText: String

    var body: some View {
        HStack(spacing: 10) {
            Avatar(friend: author, size: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(author.username)
                    .font(.vibeUsername)
                    .foregroundStyle(.white)
                Text(timestampText)
                    .font(.vibeAccentLowercase)
                    .foregroundStyle(Color.vibeSecondaryText)
            }
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        ScrollView {
            VStack(spacing: 24) {
                PostCard(post: MockDataProvider.feedPosts[0])  // unmatched
                PostCard(post: MockDataProvider.feedPosts[1])  // matched — marker visible
                PostCard(post: MockDataProvider.feedPosts[2])  // unmatched
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
    }
    .preferredColorScheme(.dark)
}
