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

    // Eagerly-bound — todayPrompt is a static var (computed) so Date() re-evaluates per access.
    let prompt: DailyPrompt = MockDataProvider.todayPrompt
}
