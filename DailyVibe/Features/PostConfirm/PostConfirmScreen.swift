//
//  PostConfirmScreen.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct PostConfirmScreen: View {
    @Binding var path: NavigationPath
    @StateObject private var vm = PostConfirmViewModel()

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            VStack(spacing: 16) {
                // POST-02 + POST-05: dual-camera photo with always-rendered marker overlay.
                // showMarker: vm.isMatched is the marker beat — flipping the toggle drives the
                // spring reveal via DualCameraPhoto's internal .animation(.spring(...), value:).
                // Photo is full-width edge-to-edge horizontally per CONTEXT.md.
                DualCameraPhoto(
                    rearAsset: "photo_capture",
                    selfieAsset: "selfie_capture",
                    showMarker: vm.isMatched
                )
                .padding(.top, 120)

                // POST-03: caption row, display only — no TextField, no editing surface.
                Text("Add a caption...")
                    .font(.vibeBody)
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                // POST-04: match toggle. Default OFF (VM-06). Direct $vm.isMatched binding
                // — works because PostConfirmViewModel.isMatched is @Published var (no private(set)).
                MatchToggleRow(prompt: vm.prompt, isMatched: $vm.isMatched)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                Spacer()

                audienceSelector

                bottomActionRow
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { closeButton }
            ToolbarItem(placement: .principal) { WordmarkHeader() }
        }
        .vibeToolbarStyling()
    }

    // POST-06: "My Friends ↓" centered, display only — no menu, no tap action.
    private var audienceSelector: some View {
        HStack(spacing: 4) {
            Text("My Friends")
            Image(systemName: "chevron.down")
        }
        .font(.system(size: 14))
        .foregroundStyle(Color.vibeSecondaryText)
    }

    // POST-06 + POST-07: bottom row — Retake (left, text, no PressableButtonStyle) +
    // Send (76pt white circle hero button, PressableButtonStyle) + invisible balance.
    // All actions use path.removeLast() (NAV-06).
    private var bottomActionRow: some View {
        HStack {
            Button("Retake") {
                path.removeLast()
            }
            .font(.system(size: 14))
            .foregroundStyle(.white)

            Spacer()

            sendButton

            Spacer()

            // Invisible balance — keeps Send visually centered against "Retake" on the left.
            Color.clear.frame(width: 56)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    // POST-07: hero Send button — filled white 76pt circle with arrow.up SF Symbol.
    // PressableButtonStyle is the second of two hero buttons (Feed shutter is the first).
    // Send action: path.removeLast() returns to Feed (NAV-06).
    private var sendButton: some View {
        Button {
            path.removeLast()
        } label: {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 76, height: 76)
                Image(systemName: "arrow.up")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.black)
            }
        }
        .buttonStyle(PressableButtonStyle())
    }

    // POST-01: chevron-down close on topBarLeading. NO PressableButtonStyle (text/icon
    // button, hero scoping rule). path.removeLast() per NAV-06.
    private var closeButton: some View {
        Button {
            path.removeLast()
        } label: {
            Image(systemName: "chevron.down")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    NavigationStack {
        PostConfirmScreen(path: .constant(NavigationPath()))
    }
    .preferredColorScheme(.dark)
}
