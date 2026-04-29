import Foundation
import SwiftUI

@MainActor
protocol AnalyticsLogger {
    func log(_ event: AnalyticsEvent)
    func identify(userId: String)
    func reset()
}

extension AnalyticsLogger {
    func identify(userId: String) {}
    func reset() {}
}

struct NoopAnalyticsLogger: AnalyticsLogger {
    func log(_ event: AnalyticsEvent) {}
}

@MainActor
final class ConsoleAnalyticsLogger: AnalyticsLogger {
    private var context: AnalyticsContext

    init(context: AnalyticsContext = .current()) {
        self.context = context
    }

    func log(_ event: AnalyticsEvent) {
        let merged = context.properties.merging(event.properties) { _, eventProp in eventProp }
        let payload = merged
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value.anyValue)" }
            .joined(separator: " ")
        print("[analytics] \(event.name) \(payload)")
    }

    func identify(userId: String) { context.userId = userId }
    func reset() { context = .current() }
}

extension EnvironmentValues {
    @Entry var analytics: any AnalyticsLogger = NoopAnalyticsLogger()
}
