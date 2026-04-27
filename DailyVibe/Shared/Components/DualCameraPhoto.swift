//
//  DualCameraPhoto.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct DualCameraPhoto: View {
    let rearAsset: String
    let selfieAsset: String
    let showMarker: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            // INNER Group — rear + selfie composite, clipped to 12pt corner radius.
            // The marker overlay sits OUTSIDE this clip (in the outer ZStack) so the
            // spring overshoot bleeds naturally into the parent's bounds (POLI-07).
            Group {
                Image(rearAsset)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

                Image(selfieAsset)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 96, height: 128)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white, lineWidth: 2.5)
                    )
                    .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 1.5)
                    .padding(.top, 12)
                    .padding(.leading, 12)
            }
            .clipShape(.rect(cornerRadius: 12))  // INNER clip — marker is NOT inside this Group

            // Marker overlay — ALWAYS rendered. Visibility controlled by scaleEffect + opacity.
            // Single .animation(_:value:) modifier applied LAST in the chain (POLI-01).
            // NEVER wrap this in a conditional branch on the flag — that destroys view identity and breaks the spring.
            VibeMarker()
                .font(.system(size: 28, weight: .bold))
                .scaleEffect(showMarker ? 1 : 0)
                .opacity(showMarker ? 1 : 0)
                .padding(.trailing, 12)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .animation(.spring(response: 0.4, dampingFraction: 0.65), value: showMarker)
        }
    }
}

#Preview("Marker Off") {
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        DualCameraPhoto(rearAsset: "photo_1", selfieAsset: "selfie_1", showMarker: false)
            .aspectRatio(3/4, contentMode: .fit)
            .padding()
    }
    .preferredColorScheme(.dark)
}

#Preview("Marker On") {
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        DualCameraPhoto(rearAsset: "photo_2", selfieAsset: "selfie_2", showMarker: true)
            .aspectRatio(3/4, contentMode: .fit)
            .padding()
    }
    .preferredColorScheme(.dark)
}

#Preview("Interactive") {
    @Previewable @State var show = false
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        VStack(spacing: 24) {
            DualCameraPhoto(rearAsset: "photo_2", selfieAsset: "selfie_2", showMarker: show)
                .aspectRatio(3/4, contentMode: .fit)
            Toggle("Match", isOn: $show)
                .padding(.horizontal)
                .foregroundStyle(.white)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
