import SwiftUI

struct PostConfirmScreen: View {
    @Environment(\.router) private var router
    @Environment(\.postRepository) private var repo
    @Environment(\.toastCenter) private var toastCenter
    @State private var vm = PostConfirmViewModel()

    var body: some View {
        @Bindable var vm = vm

        return ZStack {
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

                if let prompt = vm.promptState.value {
                    MatchToggleRow(prompt: prompt, isMatched: $vm.isMatched)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                }

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
        .task { await vm.load(repo: repo, toastCenter: toastCenter) }
    }

    // MARK: - Audience selector

    private var audienceSelector: some View {
        HStack(spacing: 4) {
            Text("My Friends")
            Image(systemName: "chevron.down")
        }
        .font(.vibeAction)
        .foregroundStyle(Color.vibeSecondaryText)
    }

    // MARK: - Bottom action row

    private var bottomActionRow: some View {
        HStack {
            Button("Retake") {
                router.pop()
            }
            .font(.vibeAction)
            .foregroundStyle(.white)

            Spacer()

            sendButton

            Spacer()

            Button("Retake") { }
                .font(.vibeAction)
                .hidden()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    // MARK: - Send button

    private var sendButton: some View {
        Button {
            router.pop()
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
            router.pop()
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
        PostConfirmScreen()
    }
    .preferredColorScheme(.dark)
    .previewEnvironments()
}
