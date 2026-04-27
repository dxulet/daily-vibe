//
//  Avatar.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct Avatar: View {
    let friend: Friend
    var size: CGFloat = 28
    var borderWidth: CGFloat? = nil

    private var resolvedBorderWidth: CGFloat {
        if let borderWidth { return borderWidth }
        // Auto-size: size / 20 rounded to nearest 0.5pt.
        // 28 -> 1.5 (face-pile), 32 -> 1.5 (PostCard username row), 20 -> 1.0 (VibeView grid overlay).
        return (size / 20.0 * 2.0).rounded() / 2.0
    }

    private var initialsFontSize: CGFloat {
        (size * 0.45).rounded()
    }

    var body: some View {
        Circle()
            .fill(friend.avatarColor)
            .frame(width: size, height: size)
            .overlay(
                Text(friend.initials)
                    .font(.system(size: initialsFontSize, weight: .semibold))
                    .foregroundStyle(.white)
            )
            .overlay(
                Circle()
                    .stroke(.white.opacity(0.92), lineWidth: resolvedBorderWidth)
            )
    }
}

#Preview {
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        VStack(spacing: 20) {
            HStack(spacing: -10) {
                ForEach(MockDataProvider.matchedFriendsToday) { friend in
                    Avatar(friend: friend)
                }
            }
            HStack(spacing: 16) {
                Avatar(friend: MockDataProvider.friends[0], size: 20)
                Avatar(friend: MockDataProvider.friends[0])           // 28pt default
                Avatar(friend: MockDataProvider.friends[0], size: 32)
                Avatar(friend: MockDataProvider.friends[0], size: 60)
            }
        }
    }
    .preferredColorScheme(.dark)
}
