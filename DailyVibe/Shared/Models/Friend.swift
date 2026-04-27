//  Friend.swift
//  DailyVibe — Shared/Models
//
//  Friend identity record. Hashable conformance is explicit id-only
//  for symmetry with Post (see Post.swift for the rationale that drives
//  the discipline). Username/initials/avatarColor are display-only.

import SwiftUI

struct Friend: Identifiable, Hashable {
    let id: UUID
    let username: String
    let initials: String
    let avatarColor: Color

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Friend, rhs: Friend) -> Bool {
        lhs.id == rhs.id
    }
}
