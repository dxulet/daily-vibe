import SwiftUI

struct LoadStateView<Value: Sendable, Loaded: View>: View {
    let state: LoadState<Value>
    let onRetry: () async -> Void
    @ViewBuilder let loaded: (Value) -> Loaded

    var body: some View {
        switch state {
        case .idle, .loading:
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let value):
            loaded(value)
        case .failed(let error):
            FailedStateView(error: error, onRetry: onRetry)
        }
    }
}

private struct FailedStateView: View {
    let error: RepositoryError
    let onRetry: () async -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: error == .offline ? "wifi.slash" : "exclamationmark.triangle.fill")
                .font(.system(size: 28))
                .foregroundStyle(Color.vibeSecondaryText)
            Text(error.userMessage)
                .font(.vibeBody)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Button {
                Task { await onRetry() }
            } label: {
                Text("Retry")
                    .font(.vibeUsername)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.white, in: .rect(cornerRadius: 12))
            }
            .buttonStyle(PressableButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
