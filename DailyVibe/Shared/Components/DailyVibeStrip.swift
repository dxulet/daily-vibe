//
//  DailyVibeStrip.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct DailyVibeStrip: View {
    let prompt: DailyPrompt
    let matchedFriends: [Friend]
    let onTap: () -> Void

    private var overflowCount: Int {
        max(0, prompt.matchedFriendsCount - matchedFriends.count)
    }

    var body: some View {
        // Width is whatever the parent allots — no screen-specific horizontal padding
        // baked into a Shared component (matches PostCard's contract).
        Button(action: onTap) {
            HStack(spacing: 12) {
                VibeMarker()
                    .font(.system(size: 14, weight: .bold))

                VStack(alignment: .leading, spacing: 2) {
                    Text("today's vibe")
                        .font(.vibeLowercaseLabel)
                        .foregroundStyle(Color.vibeSecondaryText)
                    Text(prompt.promptText)
                        .font(.vibeUsername)
                        .foregroundStyle(.white)
                }

                Spacer(minLength: 8)

                facePile
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .background(Color.vibeSurface)
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var facePile: some View {
        HStack(spacing: -10) {
            ForEach(matchedFriends.prefix(4)) { friend in
                Avatar(friend: friend)
            }
            if overflowCount > 0 {
                overflowAvatar
            }
        }
    }

    // 5th avatar-shaped circle — same 28pt size, same border, distinct fill + text.
    // Reads as "more, contained" rather than as a specific person.
    private var overflowAvatar: some View {
        Circle()
            .fill(Color.vibeSurfaceElevated)
            .frame(width: 28, height: 28)
            .overlay(
                Text("+\(overflowCount)")
                    .font(.system(size: 11, weight: .semibold))
                    .monospacedDigit()
                    .foregroundStyle(Color.vibeSecondaryText)
            )
            .overlay(
                Circle()
                    .stroke(.white.opacity(0.92), lineWidth: 1.5)
            )
    }
}

#Preview {
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        VStack(spacing: 12) {
            DailyVibeStrip(
                prompt: MockDataProvider.todayPrompt,
                matchedFriends: MockDataProvider.matchedFriendsToday,
                onTap: { print("strip tapped") }
            )
        }
    }
    .preferredColorScheme(.dark)
}
