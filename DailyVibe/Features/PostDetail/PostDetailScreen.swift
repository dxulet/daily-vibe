import SwiftUI

struct PostDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.analytics) private var analytics
    @State private var vm: PostDetailViewModel

    init(post: Post) {
        _vm = State(wrappedValue: PostDetailViewModel(post: post))
    }

    private var post: Post { vm.post }

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    DualCameraPhoto(
                        rearAsset: post.rearPhotoAsset,
                        selfieAsset: post.selfiePhotoAsset,
                        showMarker: post.isVibeMatched
                    )

                    todayVibeChip

                    Text("today felt right.")
                        .font(.vibeBody)
                        .foregroundStyle(.white)

                    realMojiRow

                    Text("0 comments")
                        .font(.vibeLowercaseLabel)
                        .foregroundStyle(Color.vibeSecondaryText)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .accessibilityLabel("Back")
            }
            ToolbarItem(placement: .principal) {
                Text("\(post.author.username)'s post.")
                    .font(.vibeToolbarTitle)
                    .foregroundStyle(.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .accessibilityHidden(true)
            }
        }
        .vibeToolbarStyling()
        .onAppear { vm.onAppear() }
        .onDisappear {
            if let event = vm.onDisappear() { analytics.log(event) }
        }
    }

    // MARK: - Today's Vibe chip

    private var todayVibeChip: some View {
        HStack(spacing: 0) {
            VibeMarker()
            Text(" today's vibe").foregroundStyle(.white)
        }
        .font(.vibeChipLabel)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.vibeSurface)
        .clipShape(.rect(cornerRadius: 12))
    }

    // MARK: - RealMoji row

    private var realMojiRow: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { _ in
                Button {
                    analytics.log(vm.reactionEvent())
                } label: {
                    Circle()
                        .fill(Color.vibeSurfaceElevated)
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailScreen(post: MockDataProvider.feedPosts[0])
    }
    .preferredColorScheme(.dark)
    .previewEnvironments()
}
