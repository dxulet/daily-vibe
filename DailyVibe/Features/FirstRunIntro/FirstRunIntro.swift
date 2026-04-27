//
//  FirstRunIntro.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct FirstRunIntro: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("FirstRunIntro")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            Text("placeholder")
                .font(.vibeAccentLowercase)
                .foregroundStyle(Color.vibeSecondaryText)
            Button("Got it") { dismiss() }
                .font(.vibeBody)
                .foregroundStyle(Color.vibeAccent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.vibeBackground)
    }
}
