//
//  VibeMarker.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

struct VibeMarker: View {
    var body: some View {
        Text("✦")
            .foregroundStyle(Color.vibeAccent)
    }
}

#Preview {
    ZStack {
        Color.vibeBackground.ignoresSafeArea()
        VibeMarker()
            .font(.system(size: 60, weight: .bold))
    }
    .preferredColorScheme(.dark)
}
