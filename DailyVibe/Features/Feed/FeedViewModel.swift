//
//  FeedViewModel.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class FeedViewModel: ObservableObject {
    // Eager init from MockDataProvider — load() simulates an async fetch but the
    // data is already on hand. Reassigning in load() would be redundant work.
    @Published private(set) var posts: [Post] = MockDataProvider.feedPosts
    @Published private(set) var todayPrompt: DailyPrompt = MockDataProvider.todayPrompt
    @Published private(set) var matchedFriends: [Friend] = MockDataProvider.matchedFriendsToday
    @Published private(set) var isLoading: Bool = false

    func load() async {
        isLoading = true
        defer { isLoading = false }

        // recording-affordance: visible 200ms loading flash for the 30s screen recording
        do { try await Task.sleep(for: .milliseconds(200)) }
        catch { return }
    }
}
