//
//  Route.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import Foundation

enum Route: Hashable {
    case feed
    case postConfirm
    case vibeView
    case postDetail(Post)
}
