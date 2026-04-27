//
//  VibeView.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

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
