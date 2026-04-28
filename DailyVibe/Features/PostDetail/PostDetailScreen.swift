import SwiftUI

struct PostDetailScreen: View {
    // DETL-01: zero-VM lock — only @Environment(\.dismiss) is permitted here.
    // Custom chevron suppresses the system back-button label inheritance
    // ("today's vibe" from VibeView's principal toolbar) which would collide
    // with the heavy "[username]'s BeReal." principal title during push.
    @Environment(\.dismiss) private var dismiss
    let post: Post

    var body: some View {
        ZStack {
            Color.vibeBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // a. DualCameraPhoto (DETL-03) — marker visibility from post.isVibeMatched (always-rendered, POLI-07).
                    DualCameraPhoto(
                        rearAsset: post.rearPhotoAsset,
                        selfieAsset: post.selfiePhotoAsset,
                        showMarker: post.isVibeMatched
                    )

                    // b. todayVibeChip (DETL-04) — yellow lives ONLY on the ✦ glyph.
                    todayVibeChip

                    // c. Caption (DETL-05) — hardcoded literal placeholder; Post model has no caption field.
                    Text("today felt right.")
                        .font(.vibeBody)
                        .foregroundStyle(.white)

                    // d. realMojiRow (DETL-06) — 3 grey placeholder circles, no interaction.
                    realMojiRow

                    // e. 0 comments text (DETL-07) — quiet, no composer.
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
                // Single-Text interpolation so iOS truncates as "username's…" instead of
                // the two-Text HStack's "username's Be…" guillotine cut on long usernames.
                Text("\(post.author.username)'s BeReal.")
                    .font(.system(size: 17, weight: .heavy))
                    .foregroundStyle(.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                // Decorative ellipsis — no Button, no tap action. Hidden from VoiceOver
                // so it doesn't announce as an interactive element.
                Image(systemName: "ellipsis")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .accessibilityHidden(true)
            }
        }
        .vibeToolbarStyling()
    }

    // MARK: - Today's Vibe chip (DETL-04)

    private var todayVibeChip: some View {
        HStack(spacing: 0) {
            VibeMarker()
            Text(" today's vibe").foregroundStyle(.white)
        }
        .font(.system(size: 12, weight: .bold))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.vibeSurface)
        .clipShape(.rect(cornerRadius: 12))
    }

    // MARK: - RealMoji row (DETL-06)

    private var realMojiRow: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { _ in
                Circle()
                    .fill(Color.vibeSurfaceElevated)
                    .frame(width: 32, height: 32)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailScreen(post: MockDataProvider.feedPosts.first!)
    }
    .preferredColorScheme(.dark)
}
