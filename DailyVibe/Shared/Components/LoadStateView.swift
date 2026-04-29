import SwiftUI

struct LoadStateView<Value, Loaded: View>: View {
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
        case .failed:
            FailedStateView(onRetry: onRetry)
        }
    }
}

private struct FailedStateView: View {
    let onRetry: () async -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 28))
                .foregroundStyle(Color.vibeSecondaryText)
            Text("Something went wrong.")
                .font(.vibeBody)
                .foregroundStyle(.white)
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
