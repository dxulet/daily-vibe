import SwiftUI

struct FeedScreen: View {
    @Binding var path: NavigationPath
    let onProfileTap: () -> Void

    @StateObject private var vm = FeedViewModel()

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                tabToggleRow
                    .padding(.top, 12)

                // Opacity-keyed (not branched) so view identity survives the 200ms loading flash.
                VStack(spacing: 0) {
                    DailyVibeStrip(
                        prompt: vm.todayPrompt,
                        matchedFriends: vm.matchedFriends,
                        onTap: { path.append(Route.vibeView) }
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(vm.posts) { post in
                                PostCard(post: post)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
                .opacity(vm.isLoading ? 0 : 1)
            }
        }
        .overlay(alignment: .bottom) {
            // Spacer-above-gradient pins the 240pt scrim to the literal screen bottom,
            // past the safe-area inset, so the darkest stop lands at the home indicator.
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                LinearGradient(
                    stops: [
                        .init(color: .clear,                              location: 0.0),
                        .init(color: Color.vibeBackground.opacity(0.4),   location: 0.4),
                        .init(color: Color.vibeBackground.opacity(0.85),  location: 0.75),
                        .init(color: Color.vibeBackground.opacity(0.95),  location: 1.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 240)
            }
            .allowsHitTesting(false)
            .ignoresSafeArea(edges: .bottom)
        }
        .overlay(alignment: .bottom) {
            shutterButton
                .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
        .task { await vm.load() }
    }

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
                    onProfileTap()
                } label: {
                    Avatar(friend: MockDataProvider.currentUser, size: 32)
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

    private var tabToggleRow: some View {
        HStack(spacing: 24) {
            Text("My Friends")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
            Text("Friends of Friends")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.vibeSecondaryText)
        }
        .frame(maxWidth: .infinity)
    }

    private var shutterButton: some View {
        Button {
            path.append(Route.postConfirm)
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
            // 88pt hit frame > 72pt visual = 8pt thumb-forgiveness past the ring.
            .frame(width: 88, height: 88)
            .contentShape(Circle())
        }
        .buttonStyle(PressableButtonStyle())
    }
}
