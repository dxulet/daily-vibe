import SwiftUI

struct MatchToggleRow: View {
    let prompt: DailyPrompt
    @Binding var isMatched: Bool

    var body: some View {
        Button(action: { isMatched.toggle() }) {
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

                Toggle("", isOn: $isMatched)
                    .labelsHidden()
                    .tint(Color.vibeAccent)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(RowPressStyle())
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
