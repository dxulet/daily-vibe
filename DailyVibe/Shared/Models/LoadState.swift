import Foundation

enum LoadState<Value: Sendable>: Sendable {
    case idle
    case loading
    case loaded(Value)
    case failed(any Error)

    var value: Value? {
        if case .loaded(let v) = self { v } else { nil }
    }

}

/// Runs `work`, posting `.loaded` on success or `.failed` + a toast on failure.
@MainActor
func resolveLoadState<Value>(
    toastCenter: ToastCenter,
    errorMessage: String,
    _ work: () async throws -> Value
) async -> LoadState<Value> {
    do {
        return .loaded(try await work())
    } catch {
        toastCenter.show(errorMessage)
        return .failed(error)
    }
}
