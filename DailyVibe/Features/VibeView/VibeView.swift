import SwiftUI

struct VibeView: View {
    @Environment(\.router) private var router
    @Environment(\.postRepository) private var repo
    @State private var vm = VibeViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            if vm.isLoading {
                EmptyView()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        promptCard(vm.prompt)

                        if vm.matchedPosts.isEmpty {
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
        .task { await vm.load(repo: repo) }
    }

    // MARK: - Prompt card

    private func promptCard(_ prompt: DailyPrompt) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Vibe #\(prompt.editionNumber)")
                .font(.vibeMetaLabel)
                .foregroundStyle(Color.vibeSecondaryText)
            Text("\(prompt.matchedFriendsCount) friends matched today")
                .font(.vibeLowercaseLabel)
                .foregroundStyle(Color.vibeSecondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.vibeSurface)
        .clipShape(.rect(cornerRadius: 16))
    }

    // MARK: - Grid

    private var grid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(vm.matchedPosts) { post in
                Button {
                    router.push(.postDetail(post))
                } label: {
                    cell(for: post)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func cell(for post: Post) -> some View {
        DualCameraPhoto(
            rearAsset: post.rearPhotoAsset,
            selfieAsset: post.selfiePhotoAsset,
            showMarker: false,
            aspect: 1
        )
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [.black.opacity(0.0), .black.opacity(0.6)],
                startPoint: .center,
                endPoint: .bottom
            )
            .clipShape(.rect(cornerRadius: 12))
            .overlay(alignment: .bottomLeading) {
                Text(post.author.username)
                    .font(.vibeGridUsername)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 6)
            }
        }
    }
}
