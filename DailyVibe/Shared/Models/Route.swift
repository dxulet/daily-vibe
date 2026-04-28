import Foundation

enum Route: Hashable {
    case feed
    case postConfirm
    case vibeView
    case postDetail(Post)
}
