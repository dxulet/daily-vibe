//  FirstRunIntro.swift
//  DailyVibe — Features/FirstRunIntro
//
//  Phase 1 stub for sheet compilation. Phase 4 fills this with the
//  real ✦ icon + "Today, BeReal has a vibe." headline + body copy +
//  "Got it" filled white button (per INTR-01..07).
//
//  Uses @Environment(\.dismiss) — NOT a Binding<Bool> from RootRouter
//  (CONTEXT.md lock; RESEARCH.md Pitfall 7).

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
