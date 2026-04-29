import SwiftUI

struct FeedScreen: View {
    @Environment(\.router) private var router
    @Environment(\.postRepository) private var repo
    @Environment(\.currentUserProvider) private var currentUserProvider
    @Environment(\.toastCenter) private var toastCenter
    @State private var vm: FeedViewModel?

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.vibeBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                tabToggleRow
                    .padding(.top, 12)

                if let vm {
                    LoadStateView(state: vm.state, onRetry: { await vm.refresh() }) { snapshot in
                    VStack(spacing: 0) {
                        DailyVibeStrip(
                            prompt: snapshot.todayPrompt,
                            matchedFriends: snapshot.matchedFriends,
                            onTap: { router.push(.vibeView) }
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(snapshot.posts) { post in
                                    PostCard(post: post)
                                }
                            }
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 100)
                        }
                    }
                }
                }
            }

            VStack(spacing: 0) {
                Spacer(minLength: 0)
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: Color.vibeBackground.opacity(0.4), location: 0.3),
                        .init(color: Color.vibeBackground.opacity(0.95), location: 0.65),
                        .init(color: Color.vibeBackground, location: 0.85),
                        .init(color: Color.vibeBackground, location: 1.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 280)
            }
            .ignoresSafeArea(edges: .bottom)

            shutterButton
                .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
        .task {
            if vm == nil {
                vm = FeedViewModel(repo: repo, toastCenter: toastCenter)
            }
            await vm?.loadIfNeeded()
        }
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack(spacing: 0) {
            Image(systemName: "person.2")
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .accessibilityLabel("Friends")

            Spacer()

            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .accessibilityLabel("Today")

                Button {
                    router.sheet = .settings
                } label: {
                    Avatar(friend: currentUserProvider.currentUser, size: 32)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Profile")
            }
        }
        .frame(maxWidth: .infinity)
        .overlay {
            WordmarkHeader()
        }
    }

    // MARK: - Tab toggle

    private var tabToggleRow: some View {
        HStack(spacing: 24) {
            Text("My Friends")
                .font(.vibeUsername)
                .foregroundStyle(.white)
            Text("Friends of Friends")
                .font(.vibeBody)
                .foregroundStyle(Color.vibeSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .accessibilityHidden(true)
    }

    // MARK: - Shutter button

    private var shutterButton: some View {
        Button {
            router.push(.postConfirm)
        } label: {
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: 4)
                    .frame(width: 72, height: 72)
                Circle()
                    .fill(.white)
                    .frame(width: 60, height: 60)
            }
            .shadow(color: .black.opacity(0.5), radius: 8, y: 2)
            .frame(width: 88, height: 88)
            .contentShape(Circle())
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview("Feed - loaded") {
    NavigationStack { FeedScreen() }
        .preferredColorScheme(.dark)
        .previewEnvironments()
}

#Preview("Feed - loading") {
    NavigationStack { FeedScreen() }
        .environment(\.postRepository, StubSlowRepository())
        .previewEnvironments()
        .preferredColorScheme(.dark)
}

#Preview("Feed - failed") {
    NavigationStack { FeedScreen() }
        .environment(\.postRepository, StubFailingRepository())
        .previewEnvironments()
        .preferredColorScheme(.dark)
}
