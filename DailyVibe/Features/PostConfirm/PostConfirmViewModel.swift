//
//  PostConfirmViewModel.swift
//  DailyVibe
//
//  Created by Daulet Ashikbayev on 27.04.2026.
//

import Combine
import SwiftUI

@MainActor
final class PostConfirmViewModel: ObservableObject {
    // Raw user-input mirror — `@Published var` (no `private(set)`) so MatchToggleRow's
    // Toggle("", isOn: $vm.isMatched).labelsHidden() binds directly without manual
    // Binding(get:set:) plumbing.
    @Published var isMatched: Bool = false

    // Computed — todayPrompt is a static var (computed) so Date() re-evaluates per access.
    // A `let` would freeze the value at VM init and contradict that intent (the prompt
    // would never roll over at midnight for a long-lived screen).
    var prompt: DailyPrompt { MockDataProvider.todayPrompt }
}
