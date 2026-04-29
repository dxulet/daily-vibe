import Foundation

enum AnalyticsEvent: Equatable, Sendable {
    case dailyVibeNotificationOpened(promptId: String, timeToOpenSeconds: Int)
    case dailyVibeMatchToggled(promptId: String, matchValue: Bool)
    case dailyVibePostPublished(promptId: String, isVibeMatch: Bool)
    case dailyVibeStripTapped(promptId: String, friendsMatchedCountVisible: Int)
    case dailyVibePostViewed(postId: String, dwellMs: Int, surface: String)
    case dailyVibeReactionAdded(postId: String, reactionType: String, surface: String)
    case notificationPermissionDenied(lastPostDaysAgo: Int)

    var name: String {
        switch self {
        case .dailyVibeNotificationOpened: return "daily_vibe_notification_opened"
        case .dailyVibeMatchToggled: return "daily_vibe_match_toggled"
        case .dailyVibePostPublished: return "daily_vibe_post_published"
        case .dailyVibeStripTapped: return "daily_vibe_strip_tapped"
        case .dailyVibePostViewed: return "daily_vibe_post_viewed"
        case .dailyVibeReactionAdded: return "daily_vibe_reaction_added"
        case .notificationPermissionDenied: return "notification_permission_denied"
        }
    }

    var properties: [String: AnalyticsProperty] {
        switch self {
        case let .dailyVibeNotificationOpened(promptId, timeToOpenSeconds):
            return ["prompt_id": .string(promptId), "time_to_open_seconds": .int(timeToOpenSeconds)]
        case let .dailyVibeMatchToggled(promptId, matchValue):
            return ["prompt_id": .string(promptId), "match_value": .bool(matchValue)]
        case let .dailyVibePostPublished(promptId, isVibeMatch):
            return ["prompt_id": .string(promptId), "is_vibe_match": .bool(isVibeMatch)]
        case let .dailyVibeStripTapped(promptId, friendsMatchedCountVisible):
            return ["prompt_id": .string(promptId), "friends_matched_count_visible": .int(friendsMatchedCountVisible)]
        case let .dailyVibePostViewed(postId, dwellMs, surface):
            return ["post_id": .string(postId), "dwell_ms": .int(dwellMs), "surface": .string(surface)]
        case let .dailyVibeReactionAdded(postId, reactionType, surface):
            return ["post_id": .string(postId), "reaction_type": .string(reactionType), "surface": .string(surface)]
        case let .notificationPermissionDenied(lastPostDaysAgo):
            return ["last_post_days_ago": .int(lastPostDaysAgo)]
        }
    }
}
