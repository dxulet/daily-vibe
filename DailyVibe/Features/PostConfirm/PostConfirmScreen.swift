//
//  PostConfirmScreen.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct PostConfirmScreen: View {
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()
            VStack(spacing: 8) {
                Text("PostConfirm")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("placeholder")
                    .font(.vibeAccentLowercase)
                    .foregroundStyle(Color.vibeSecondaryText)

                Button("close (path.removeLast())") {
                    path.removeLast()
                }
                .font(.vibeBody)
                .foregroundStyle(Color.vibeAccent)
                .padding(.top, 16)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
