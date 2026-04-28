import Combine
import Foundation
import SwiftUI

@MainActor
final class VibeViewModel: ObservableObject {
    @Published private(set) var prompt: DailyPrompt = MockDataProvider.todayPrompt
    @Published private(set) var matchedPosts: [Post] = []
    @Published private(set) var isLoading: Bool = false

    func load() async {
        isLoading = true
        defer { isLoading = false }

        // recording-affordance: visible 200ms loading flash for the 30s screen recording
        do { try await Task.sleep(for: .milliseconds(200)) }
        catch { return }

        prompt = MockDataProvider.todayPrompt
        matchedPosts = MockDataProvider.matchedPosts
    }
}
