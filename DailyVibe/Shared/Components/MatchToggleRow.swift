import SwiftUI

struct MatchToggleRow: View {
    @Environment(\.analytics) private var analytics
    let prompt: DailyPrompt
    @Binding var isMatched: Bool

    var body: some View {
        Button(action: {
            isMatched.toggle()
            analytics.log(.dailyVibeMatchToggled(promptId: prompt.promptId, matchValue: isMatched))
        }) {
            HStack(spacing: 12) {
                VibeMarker()
                    .font(.system(size: 20, weight: .bold))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Match today's vibe?")
                        .font(.vibeUsername)
                        .foregroundStyle(.white)
                    Text("today: \(prompt.promptText)")
                        .font(.vibeLowercaseLabel)
                        .foregroundStyle(Color.vibeSecondaryText)
                }

                Spacer(minLength: 12)

                ToggleSwitch(isOn: isMatched)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// Visual-only — the parent Button owns the tap. A real `Toggle` here would
// double-toggle the binding.
private struct ToggleSwitch: View {
    let isOn: Bool

    var body: some View {
        Capsule()
            .fill(isOn ? Color.vibeAccent : Color.vibeSurfaceElevated)
            .frame(width: 50, height: 30)
            .overlay(alignment: isOn ? .trailing : .leading) {
                Circle()
                    .fill(.white)
                    .frame(width: 26, height: 26)
                    .padding(2)
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: isOn)
    }
}

#Preview {
    @Previewable @State var matched = false
    return ZStack {
        Color.vibeBackground.ignoresSafeArea()
        VStack(spacing: 24) {
            MatchToggleRow(prompt: MockDataProvider.todayPrompt, isMatched: $matched)
            Text(matched ? "isMatched: true" : "isMatched: false")
                .font(.vibeLowercaseLabel)
                .foregroundStyle(Color.vibeSecondaryText)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
