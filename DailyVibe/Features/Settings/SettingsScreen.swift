//  SettingsScreen.swift
//  DailyVibe — Features/Settings
//
//  Phase 1 stub for sheet compilation. Phase 4 fills this with the
//  real iOS list (SETT-01..05).

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            Text("placeholder")
                .font(.vibeAccentLowercase)
                .foregroundStyle(Color.vibeSecondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.vibeBackground)
    }
}
