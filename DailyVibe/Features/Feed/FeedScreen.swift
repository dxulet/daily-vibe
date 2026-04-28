//
//  FeedScreen.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct FeedScreen: View {
    @Binding var path: NavigationPath
    let onProfileTap: () -> Void

    @StateObject private var vm = FeedViewModel()

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                tabToggleRow
                    .padding(.top, 12)

                // Always-rendered subtree — opacity-keyed on isLoading preserves view
                // identity through the 200ms recording flash (matches the marker-overlay
                // and MatchToggleRow patterns: "modifiers over conditional views").
                VStack(spacing: 0) {
                    DailyVibeStrip(
                        prompt: vm.todayPrompt,
                        matchedFriends: vm.matchedFriends,
                        onTap: { path.append(Route.vibeView) }
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(vm.posts) { post in
                                PostCard(post: post)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
                .opacity(vm.isLoading ? 0 : 1)
            }
        }
        .overlay(alignment: .bottom) {
            // Scrim anchored to the literal SCREEN bottom (past the home indicator).
            // VStack with a Spacer above the gradient lets the gradient size itself to
            // its natural 240pt and stick to the bottom of a full-screen frame that
            // ignores the safe area — so the darkest stop lands at the screen edge,
            // not at the safe-area inset.
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                LinearGradient(
                    stops: [
                        .init(color: .clear,                              location: 0.0),
                        .init(color: Color.vibeBackground.opacity(0.4),   location: 0.4),
                        .init(color: Color.vibeBackground.opacity(0.85),  location: 0.75),
                        .init(color: Color.vibeBackground.opacity(0.95),  location: 1.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 240)
            }
            .allowsHitTesting(false)
            .ignoresSafeArea(edges: .bottom)
        }
        .overlay(alignment: .bottom) {
            shutterButton
                .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
        .task { await vm.load() }
    }

    // FEED-01: top bar — friends icon (left) + WordmarkHeader (center) + calendar + profile (right).
    // Use overlay-centered WordmarkHeader so the side clusters can size naturally without
    // unbounded Spacers fighting the centered title for width.
    private var topBar: some View {
        HStack(spacing: 0) {
            Image(systemName: "person.2")
                .font(.system(size: 22))
                .foregroundStyle(.white)

            Spacer()

            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)

                Button {
                    onProfileTap()
                } label: {
                    Avatar(friend: MockDataProvider.currentUser, size: 32)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Profile")
            }
        }
        .frame(maxWidth: .infinity)
        .overlay {
            WordmarkHeader()
        }
    }

    // FEED-02: tab toggle row — purely visual, no tap behavior, no separator.
    private var tabToggleRow: some View {
        HStack(spacing: 24) {
            Text("My Friends")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
            Text("Friends of Friends")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.vibeSecondaryText)
        }
        .frame(maxWidth: .infinity)
    }

    // FEED-07: hero shutter floats on the gradient scrim — white ring + filled disc.
    // Tight shadow earns elevation without bleeding into a hard opacity wall (the scrim
    // never reaches 1.0 at bottom, so the shadow has room to dissipate).
    private var shutterButton: some View {
        Button {
            path.append(Route.postConfirm)
        } label: {
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: 4)
                    .frame(width: 72, height: 72)
                Circle()
                    .fill(.white)
                    .frame(width: 60, height: 60)
            }
            .shadow(color: .black.opacity(0.5), radius: 8, y: 2)
            .contentShape(Circle())
        }
        .buttonStyle(PressableButtonStyle())
    }
}
