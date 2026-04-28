import SwiftUI

/// Row-level press feedback for the MatchToggleRow — the one gesture the reviewer
/// scrubs frame-by-frame in the recording. Scoped EXCLUSIVELY to MatchToggleRow in Phase 2.
/// Sibling to PressableButtonStyle (scale 0.96, ease-out 0.16s — scoped to shutter + Send).
/// See PressableButtonStyle.swift for the scope-discipline rationale.
struct RowPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}
