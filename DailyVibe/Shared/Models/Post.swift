//  Post.swift
//  DailyVibe — Shared/Models
//
//  A user's post in the feed or vibe grid. CRITICAL: Hashable conformance
//  is explicit id-only — synthesized hashing would include the timestampText
//  String and the isVibeMatched Bool, making NavigationPath.append(.postDetail(post))
//  produce two distinct stack entries for the same logical post on a re-tap.
//
//  Two-string photo asset references (rearPhotoAsset, selfiePhotoAsset) are
//  the locked Phase 1 shape per CONTEXT.md — no nested PhotoPair struct.
//  DualCameraPhoto (Phase 2) reads both fields and looks them up via Image("name").
//
//  See: STATE.md Phase 1 decision; CONTEXT.md "Photo asset reference type on Post";
//       RESEARCH.md Pitfall 1.

import Foundation
import SwiftUI

struct Post: Identifiable, Hashable {
    let id: UUID
    let author: Friend
    let rearPhotoAsset: String   // e.g. "photo_1" — looked up via Image("photo_1")
    let selfiePhotoAsset: String // e.g. "selfie_1"
    let timestampText: String    // e.g. "now", "2h late" — display string only
    let isVibeMatched: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}
