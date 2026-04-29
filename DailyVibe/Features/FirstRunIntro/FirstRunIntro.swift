import SwiftUI

struct FirstRunIntro: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false

    var body: some View {
        VStack(spacing: 24) {
            VibeMarker()
                .font(.system(size: 60, weight: .bold))

            Text("Today has a vibe.")
                .font(.vibeIntroHeadline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("Each day, everyone gets the same prompt. Match it if you want, ignore it if you don't.")
                .font(.vibeBody)
                .foregroundStyle(Color.vibeSecondaryText)
                .multilineTextAlignment(.center)

            Button {
                hasSeenIntro = true
                dismiss()
            } label: {
                Text("Got it")
                    .font(.vibeUsername)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.white, in: .rect(cornerRadius: 14))
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.vibeBackground)
        .presentationDetents([.medium])
        .toastHost()
    }
}

#Preview {
    Color.gray.sheet(isPresented: .constant(true)) {
        FirstRunIntro()
    }
    .preferredColorScheme(.dark)
    .previewEnvironments()
}
