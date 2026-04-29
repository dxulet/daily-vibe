import SwiftUI

struct WordmarkHeader: View {
    var body: some View {
        Text("Daily Vibe.")
            .font(.vibeWordmark)
            .foregroundStyle(.white)
    }
}

#Preview {
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        WordmarkHeader()
    }
    .preferredColorScheme(.dark)
}
