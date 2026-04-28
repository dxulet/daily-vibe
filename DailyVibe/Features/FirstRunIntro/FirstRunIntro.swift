import SwiftUI

struct FirstRunIntro: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            VibeMarker()
                .font(.system(size: 60, weight: .bold))

            Text("Today, BeReal has a vibe.")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("Each day, everyone gets the same prompt. Match it if you want, ignore it if you don't.")
                .font(.vibeBody)
                .foregroundStyle(Color.vibeSecondaryText)
                .multilineTextAlignment(.center)

            Spacer().frame(height: 8)

            Button("Got it") { dismiss() }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.white)
                .foregroundStyle(.black)
                .clipShape(.rect(cornerRadius: 14))
                .font(.vibeBody.weight(.semibold))
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.vibeBackground)
        .presentationDetents([.medium])
    }
}

#Preview {
    Color.gray.sheet(isPresented: .constant(true)) {
        FirstRunIntro()
    }
    .preferredColorScheme(.dark)
}
