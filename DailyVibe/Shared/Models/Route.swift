//  Route.swift
//  DailyVibe — Shared/Models
//
//  The single navigation route enum. Hashable is synthesized (all
//  associated value types are Hashable; Post: Hashable is id-only,
//  which keeps NavigationPath.append(.postDetail(post)) idempotent).
//
//  RootRouter wires .navigationDestination(for: Route.self) over
//  these four cases. Feature screens push by calling
//  path.wrappedValue.append(Route.X) directly.
//
//  Note: .feed exists for API completeness even though FeedScreen
//  is the nav-stack root (rarely fires in practice).
//  See FOUN-06.

import Foundation

enum Route: Hashable {
    case feed
    case postConfirm
    case vibeView
    case postDetail(Post)
}
