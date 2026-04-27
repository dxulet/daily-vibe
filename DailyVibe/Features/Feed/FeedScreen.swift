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
