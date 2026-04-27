//  PostConfirmScreen.swift
//  DailyVibe — Features/PostConfirm
//
//  Phase 1 placeholder. Phase 3 grows this into the real PostConfirm
//  (DualCameraPhoto + MatchToggleRow + Send button). Per CONTEXT.md
//  "Photo asset reference type on Post", PostConfirm hardcodes
//  "photo_capture" + "selfie_capture" directly in the view body
//  (Phase 3) — NOT a Post value, NOT consuming MockDataProvider.

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

                // Demo NAV-06 wiring (path.removeLast()). Phase 3
                // replaces this with the real Send / Retake / Close
                // buttons that all call path.removeLast().
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
