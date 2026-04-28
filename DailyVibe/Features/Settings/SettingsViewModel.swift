import Combine
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    // Raw user-input mirror — `@Published var` (no `private(set)`) so SettingsScreen's
    // Toggle binding works directly without manual Binding(get:set:) plumbing.
    @Published var isVibeEnabled: Bool = true
}
