import SwiftUI

struct Avatar: View {
    let friend: Friend
    var size: CGFloat = 28
    var borderWidth: CGFloat? = nil

    var body: some View {
        let metrics = Metrics(size: size, borderWidth: borderWidth)
        Circle()
            .fill(friend.avatarColor)
            .frame(width: size, height: size)
            .overlay(
                Text(friend.initials)
                    .font(.system(size: metrics.initialsFontSize, weight: .semibold))
                    .foregroundStyle(.white)
            )
            .overlay(
                Circle()
                    .stroke(.white.opacity(0.92), lineWidth: metrics.borderWidth)
            )
    }
}

extension Avatar {
    /// Pure-math sizing derived from `size` and an optional override `borderWidth`.
    /// Auto-sized border = `size / 20` rounded to nearest 0.5pt.
    fileprivate struct Metrics {
        let borderWidth: CGFloat
        let initialsFontSize: CGFloat

        init(size: CGFloat, borderWidth: CGFloat?) {
            self.borderWidth = borderWidth ?? (size / 20.0 * 2.0).rounded() / 2.0
            self.initialsFontSize = (size * 0.45).rounded()
        }
    }
}

#Preview {
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        VStack(spacing: 20) {
            HStack(spacing: -10) {
                ForEach(MockDataProvider.matchedFriendsToday) { friend in
                    Avatar(friend: friend)
                }
            }
            HStack(spacing: 16) {
                Avatar(friend: MockDataProvider.friends[0], size: 20)
                Avatar(friend: MockDataProvider.friends[0])
                Avatar(friend: MockDataProvider.friends[0], size: 32)
                Avatar(friend: MockDataProvider.friends[0], size: 60)
            }
        }
    }
    .preferredColorScheme(.dark)
}
