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
    var aspect: CGFloat = 3/4  // 3:4 for feed/detail, 1:1 for VibeView grid

    // Asset-agnostic loaders — render the image if it's in the catalog,
    // otherwise fall back to a tinted placeholder so PostCards stay visible
    // before real photo assets are dropped into Assets.xcassets.
    private var rearImage: some View {
        ZStack {
            Color(white: 0.18)
            if UIImage(named: rearAsset) != nil {
                Image(rearAsset)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 36))
                    .foregroundStyle(.white.opacity(0.25))
            }
        }
    }

    private var selfieImage: some View {
        ZStack {
            Color(white: 0.28)
            if UIImage(named: selfieAsset) != nil {
                Image(selfieAsset)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.white.opacity(0.35))
            }
        }
    }

    var body: some View {
        // Aspect baked in — every DualCameraPhoto is 3:4, regardless of source image dimensions.
        // Callers no longer need to set .aspectRatio externally; that was producing inconsistent
        // crops when source aspect varied (square vs portrait vs landscape).
        Color.clear
            .aspectRatio(aspect, contentMode: .fit)
            .overlay {
                rearImage
                    .clipped()
            }
            .overlay(alignment: .topLeading) {
                selfieImage
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
            .clipShape(.rect(cornerRadius: 12))
            .overlay(alignment: .bottomTrailing) {
                // Marker overlay — ALWAYS rendered. Visibility controlled by scaleEffect + opacity.
                // Single .animation(_:value:) modifier applied LAST in the chain (POLI-01).
                // NEVER wrap this in a conditional branch on the flag — that destroys view identity and breaks the spring.
                VibeMarker()
                    .font(.system(size: 28, weight: .bold))
                    .scaleEffect(showMarker ? 1 : 0)
                    .opacity(showMarker ? 1 : 0)
                    .padding(.trailing, 12)
                    .padding(.bottom, 12)
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
