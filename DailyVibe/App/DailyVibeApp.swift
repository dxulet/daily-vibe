//
//  DailyVibeApp.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import SwiftUI

@main
struct DailyVibeApp: App {
    var body: some Scene {
        WindowGroup {
            RootRouter()
                .preferredColorScheme(.dark)
        }
    }
}
