//
//  PressableButtonStyle.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

/// Hero-button press feedback: scale-0.96 ease-out 160ms.
/// Scoped to shutter (Feed) and Send (PostConfirm) ONLY — not grid cells, profile circle, Retake, or 3-dot menu.
/// Reason: in a 30-second recording with ~7-8 scripted taps, applying press-feedback to every tappable surface
/// generates secondary motion events that compete with the marker spring. Two events keeps the marker dominant.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}
