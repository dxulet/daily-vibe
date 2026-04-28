//
//  ToolbarStyling.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

extension View {
    func vibeToolbarStyling() -> some View {
        self
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.vibeBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
