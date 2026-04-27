//
//  WordmarkHeader.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct WordmarkHeader: View {
    var body: some View {
        Text("BeReal.")
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
