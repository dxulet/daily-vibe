//
//  Post.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import Foundation
import SwiftUI

struct Post: Identifiable, Hashable {
    let id: UUID
    let author: Friend
    let rearPhotoAsset: String
    let selfiePhotoAsset: String
    let timestampText: String
    let isVibeMatched: Bool

    // id-only Hashable: keeps NavigationPath.append(.postDetail(post)) idempotent.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}
