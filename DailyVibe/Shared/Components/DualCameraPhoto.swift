import SwiftUI

struct DualCameraPhoto: View {
    let rearAsset: String
    let selfieAsset: String
    let showMarker: Bool
    var aspect: CGFloat = 3/4

    var body: some View {
        Color.clear
            .aspectRatio(aspect, contentMode: .fit)
            .overlay {
                AssetImage(assetName: rearAsset, backgroundColor: Color(white: 0.18)) {
                    Image(systemName: "photo")
                        .font(.system(size: 36))
                        .foregroundStyle(.white.opacity(0.25))
                }
                .clipped()
            }
            .overlay(alignment: .topLeading) {
                AssetImage(assetName: selfieAsset, backgroundColor: Color(white: 0.28)) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.35))
                }
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
                // POLI-07: always-rendered, controlled via scaleEffect/opacity. Never branch this on the flag.
                VibeMarker()
                    .font(.system(size: 28, weight: .bold))
                    .scaleEffect(showMarker ? 1 : 0)
                    .opacity(showMarker ? 1 : 0)
                    .padding(.trailing, 12)
                    .padding(.bottom, 12)
                    .accessibilityHidden(true)
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
