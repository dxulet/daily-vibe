import SwiftUI

struct PostConfirmScreen: View {
    @Binding var path: NavigationPath
    @StateObject private var vm = PostConfirmViewModel()

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            VStack(spacing: 16) {
                DualCameraPhoto(
                    rearAsset: "photo_capture",
                    selfieAsset: "selfie_capture",
                    showMarker: vm.isMatched
                )

                Text("Add a caption...")
                    .font(.vibeBody)
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

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

    // MARK: - Audience selector

    private var audienceSelector: some View {
        HStack(spacing: 4) {
            Text("My Friends")
            Image(systemName: "chevron.down")
        }
        .font(.system(size: 14))
        .foregroundStyle(Color.vibeSecondaryText)
    }

    // MARK: - Bottom action row

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

            // Invisible Retake duplicate balances the row; width auto-tracks under
            // localization and Dynamic Type without a magic constant.
            Button("Retake") { }
                .font(.system(size: 14))
                .hidden()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    // MARK: - Send button

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
        .accessibilityLabel("Send")
    }

    // MARK: - Close button

    private var closeButton: some View {
        Button {
            path.removeLast()
        } label: {
            Image(systemName: "chevron.down")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
        }
        .accessibilityLabel("Close")
    }
}

#Preview {
    NavigationStack {
        PostConfirmScreen(path: .constant(NavigationPath()))
    }
    .preferredColorScheme(.dark)
}
