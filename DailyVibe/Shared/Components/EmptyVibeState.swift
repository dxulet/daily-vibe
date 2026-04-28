import SwiftUI

struct EmptyVibeState: View {
    var body: some View {
        VStack(spacing: 16) {
            VibeMarker()
                .font(.system(size: 60, weight: .bold))

            Text("no vibes yet")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)

            Text("match today's vibe to see who else did")
                .font(.vibeLowercaseLabel)
                .foregroundStyle(Color.vibeSecondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
    }
}

#Preview {
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        EmptyVibeState()
    }
    .preferredColorScheme(.dark)
}
