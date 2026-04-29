import Foundation

enum LoadState<Value: Sendable>: Sendable {
    case idle
    case loading
    case loaded(Value)
    case failed(any Error)

    var value: Value? {
        if case .loaded(let v) = self { v } else { nil }
    }

    var isLoading: Bool {
        if case .loading = self { true } else { false }
    }
}
