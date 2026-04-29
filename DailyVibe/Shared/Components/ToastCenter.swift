import SwiftUI

@Observable
@MainActor
final class ToastCenter {
    struct Toast: Identifiable, Equatable {
        enum Kind: Equatable { case error, info }
        let id = UUID()
        let kind: Kind
        let message: String
    }

    private(set) var current: Toast?
    private var dismissTask: Task<Void, Never>?

    nonisolated init() {}

    func show(_ message: String, kind: Toast.Kind = .error, duration: Duration = .seconds(3)) {
        dismissTask?.cancel()
        current = Toast(kind: kind, message: message)
        dismissTask = Task { [weak self] in
            try? await Task.sleep(for: duration)
            guard !Task.isCancelled else { return }
            self?.current = nil
        }
    }

    func dismiss() {
        dismissTask?.cancel()
        current = nil
    }
}

extension EnvironmentValues {
    @Entry var toastCenter: ToastCenter = ToastCenter()
}

struct ToastBanner: View {
    let toast: ToastCenter.Toast

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: toast.kind == .error ? "exclamationmark.triangle.fill" : "info.circle.fill")
                .foregroundStyle(.white)
            Text(toast.message)
                .font(.vibeBody)
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(toast.kind == .error ? Color.red.opacity(0.92) : Color.vibeSurface)
        )
        .padding(.horizontal, 16)
    }
}

private struct ToastHostModifier: ViewModifier {
    @Environment(\.toastCenter) private var center

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast = center.current {
                    ToastBanner(toast: toast)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onTapGesture { center.dismiss() }
                        .accessibilityAddTraits(.isStaticText)
                        .accessibilityElement(children: .combine)
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: center.current)
    }
}

extension View {
    func toastHost() -> some View {
        modifier(ToastHostModifier())
    }
}

#if DEBUG
extension ToastCenter {
    static func previewSeeded(_ message: String, kind: Toast.Kind = .error) -> ToastCenter {
        let center = ToastCenter()
        center.current = Toast(kind: kind, message: message)
        return center
    }
}

#Preview("Banner - error") {
    ToastBanner(toast: .init(kind: .error, message: "Couldn't load your feed. Pull to refresh."))
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.vibeBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
}

#Preview("Banner - info") {
    ToastBanner(toast: .init(kind: .info, message: "Saved to your camera roll."))
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.vibeBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
}

#Preview("Hosted - seeded") {
    Color.vibeBackground.ignoresSafeArea()
        .environment(\.toastCenter, .previewSeeded("Couldn't load your feed. Pull to refresh."))
        .toastHost()
        .preferredColorScheme(.dark)
}
#endif
