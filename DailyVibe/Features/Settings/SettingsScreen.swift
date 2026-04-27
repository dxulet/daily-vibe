//
//  SettingsScreen.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

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
