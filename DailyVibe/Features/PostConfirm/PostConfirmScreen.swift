import SwiftUI

struct PostConfirmScreen: View {
    @Environment(\.router) private var router
    @Environment(\.postRepository) private var repo
    @Environment(\.toastCenter) private var toastCenter
    @Environment(\.analytics) private var analytics
    @State private var vm: PostConfirmViewModel?

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            if let vm {
                @Bindable var vm = vm

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

                    LoadStateView(
                        state: vm.promptState,
                        onRetry: { await vm.refresh() }
                    ) { prompt in
                        MatchToggleRow(prompt: prompt, isMatched: $vm.isMatched)
                    }
                    .frame(minHeight: 62)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                    Spacer()

                    audienceSelector

                    bottomActionRow
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { closeButton }
            ToolbarItem(placement: .principal) { WordmarkHeader() }
        }
        .vibeToolbarStyling()
        .task {
            if vm == nil {
                vm = PostConfirmViewModel(repo: repo, toastCenter: toastCenter)
            }
            await vm?.loadIfNeeded()
        }
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
        ZStack {
            sendButton

            Button("Retake") {
                router.pop()
            }
            .font(.vibeAction)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    // MARK: - Send button

    private var sendButton: some View {
        Button {
            Task {
                guard let vm, let prompt = await vm.publish() else { return }
                analytics.log(.dailyVibePostPublished(promptId: prompt.promptId, isVibeMatch: vm.isMatched))
                router.push(.vibeView)
            }
        } label: {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 76, height: 76)
                Image(systemName: "arrow.up")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.black)
            }
            .opacity((vm?.canPublish ?? false) ? 1 : 0.4)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(!(vm?.canPublish ?? false))
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
