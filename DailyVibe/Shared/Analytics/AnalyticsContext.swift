import Foundation

struct AnalyticsContext: Sendable {
    var userId: String?
    var sessionId: String
    var appVersion: String
    var locale: String
    var country: String
    var experimentDailyVibeVariant: String

    var properties: [String: AnalyticsProperty] {
        var out: [String: AnalyticsProperty] = [
            "session_id": .string(sessionId),
            "app_version": .string(appVersion),
            "os": .string("iOS"),
            "locale": .string(locale),
            "country": .string(country),
            "experiment_daily_vibe_variant": .string(experimentDailyVibeVariant),
        ]
        if let userId { out["user_id"] = .string(userId) }
        return out
    }

    static func current() -> AnalyticsContext {
        AnalyticsContext(
            userId: nil,
            sessionId: UUID().uuidString,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0",
            locale: Locale.current.identifier,
            country: Locale.current.region?.identifier ?? "ZZ",
            experimentDailyVibeVariant: "control"
        )
    }
}
