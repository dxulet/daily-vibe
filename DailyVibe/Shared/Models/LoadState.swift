import Foundation

enum LoadState<Value: Sendable>: Sendable {
    case idle
    case loading
    case loaded(Value)
    case failed(RepositoryError)

    var value: Value? {
        if case .loaded(let v) = self { v } else { nil }
    }

    var error: RepositoryError? {
        if case .failed(let e) = self { e } else { nil }
    }
}

@MainActor
func resolveLoadState<Value>(
    toastCenter: ToastCenter,
    errorMessage: String,
    _ work: () async throws -> Value
) async -> LoadState<Value>? {
    do {
        let value = try await work()
        if Task.isCancelled { return nil }
        return .loaded(value)
    } catch is CancellationError {
        return nil
    } catch {
        if Task.isCancelled { return nil }
        toastCenter.show(errorMessage)
        return .failed(error.asRepositoryError)
    }
}
