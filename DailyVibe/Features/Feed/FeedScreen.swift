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
                tabToggleRow

                if vm.isLoading {
                    Spacer()
                } else {
                    DailyVibeStrip(
                        prompt: vm.todayPrompt,
                        matchedFriends: vm.matchedFriends,
                        onTap: { path.append(Route.vibeView) }
                    )
                    .padding(.top, 12)

                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(vm.posts) { post in
                                PostCard(post: post)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            shutterButton
                .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
        .task { await vm.load() }
    }

    // FEED-01: top bar — friends icon + WordmarkHeader + calendar + profile circle.
    private var topBar: some View {
        HStack(spacing: 0) {
            Image(systemName: "person.2")
                .font(.system(size: 24))
                .foregroundStyle(.white)

            Spacer()

            WordmarkHeader()

            Spacer()

            Image(systemName: "calendar")
                .font(.system(size: 22))
                .foregroundStyle(.white)

            Spacer().frame(width: 12)

            Button {
                onProfileTap()
            } label: {
                profileCircle
            }
            .buttonStyle(.plain)
            .frame(width: 40, height: 40)
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // FEED-08: profile circle with literal "Y" initial, vibeAvatarMuted fill, white stroke.
    private var profileCircle: some View {
        ZStack {
            Circle().fill(Color.vibeAvatarMuted)
            Text("Y")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(width: 32, height: 32)
        .overlay(Circle().stroke(.white, lineWidth: 1.5))
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
        .padding(.top, 8)
    }

    // FEED-07: shutter — stroked white ring (NOT filled), PressableButtonStyle hero scope.
    private var shutterButton: some View {
        Button {
            path.append(Route.postConfirm)
        } label: {
            Circle()
                .stroke(.white, lineWidth: 3)
                .frame(width: 76, height: 76)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
