//  FeedScreen.swift
//  DailyVibe — Features/Feed
//
//  Phase 1 placeholder. The stack root inside RootRouter's nav stack.
//  Phase 3 grows this into the real Feed (DailyVibeStrip + 3 PostCard rows
//  + shutter button). For Phase 1, a debug button row demonstrates that
//  every Route push fires (Phase 1 Success Criterion 2).
//
//  Signature: receives Binding<NavigationPath> for autonomous push,
//  and onProfileTap closure for opening the Settings sheet (NAV-04 +
//  CONTEXT.md "RootRouter wiring": closure callback, not Binding<Bool>).

import SwiftUI

struct FeedScreen: View {
    @Binding var path: NavigationPath
    let onProfileTap: () -> Void

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Feed")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("placeholder — phase 1 stack root")
                    .font(.vibeAccentLowercase)
                    .foregroundStyle(Color.vibeSecondaryText)

                // Debug push buttons — demonstrate every Route case fires.
                // Phase 3 deletes this block when the real Feed body lands.
                VStack(spacing: 8) {
                    Button("push postConfirm") {
                        path.append(Route.postConfirm)
                    }
                    Button("push vibeView") {
                        path.append(Route.vibeView)
                    }
                    Button("push postDetail (matched post)") {
                        path.append(Route.postDetail(MockDataProvider.feedPosts[1]))
                    }
                    Button("open Settings sheet") {
                        onProfileTap()
                    }
                }
                .font(.vibeBody)
                .foregroundStyle(Color.vibeAccent)
                .padding(.top, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
