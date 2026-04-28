//
//  VibeView.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct VibeView: View {
    @Binding var path: NavigationPath
    @StateObject private var vm = VibeViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            if vm.isLoading {
                // 200ms loading flash (VIBE-07) — chrome (toolbar) renders above; body is empty.
                EmptyView()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        promptCard(vm.prompt)

                        if vm.matchedPosts.isEmpty {
                            // Inline empty-state replacement (VIBE-06): prompt card stays visible above.
                            // Mock data always returns 6 so this never fires in the recording, but the
                            // code path exists for craft signal when grepped.
                            EmptyVibeState()
                        } else {
                            grid
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text("today's vibe")
                        .font(.vibeLowercaseLabel)
                        .foregroundStyle(Color.vibeSecondaryText)
                    Text(vm.prompt.promptText)
                        .font(.vibeUsername)
                        .foregroundStyle(.white)
                }
            }
        }
        .vibeToolbarStyling()
        .task { await vm.load() }
    }

    // MARK: - Prompt card (VIBE-02)

    private func promptCard(_ prompt: DailyPrompt) -> some View {
        // The prompt itself lives on the toolbar principal item — rendering it here too
        // produced two copies of the same string ~80pt apart on screen.
        VStack(alignment: .leading, spacing: 8) {
            Text("Vibe #\(prompt.editionNumber)")
                .font(.system(size: 12))
                .foregroundStyle(Color.vibeSecondaryText)
            Text("\(prompt.matchedFriendsCount) friends matched today")
                .font(.system(size: 13))
                .foregroundStyle(Color.vibeSecondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.vibeSurface)
        .clipShape(.rect(cornerRadius: 16))
    }

    // MARK: - Grid (VIBE-03..VIBE-05)

    private var grid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(vm.matchedPosts) { post in
                Button {
                    path.append(Route.postDetail(post))
                } label: {
                    cell(for: post)
                }
                .buttonStyle(.plain)  // hero-only press feedback (CONTEXT.md) — NO PressableButtonStyle
            }
        }
    }

    private func cell(for post: Post) -> some View {
        // showMarker: false — the grid IS the vibe-matched surface; per-cell
        // ✦ markers are redundant noise and previously collided with the
        // bottom-leading username scrim on the same 16pt edge strip,
        // muddying the precious yellow accent.
        DualCameraPhoto(
            rearAsset: post.rearPhotoAsset,
            selfieAsset: post.selfiePhotoAsset,
            showMarker: false,
            aspect: 1
        )
        .overlay(alignment: .bottom) {
            // Scrim is the only surface that needs the rounded clip — DualCameraPhoto
            // already clips its body internally; re-imposing an outer clip on the cell
            // would re-clip the marker overlay sibling and break POLI-07's spring-overshoot
            // bleed contract.
            LinearGradient(
                colors: [.black.opacity(0.0), .black.opacity(0.6)],
                startPoint: .center,
                endPoint: .bottom
            )
            .clipShape(.rect(cornerRadius: 12))
            .overlay(alignment: .bottomLeading) {
                Text(post.author.username)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 6)
            }
        }
    }
}
