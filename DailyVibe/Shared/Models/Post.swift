import Foundation
import SwiftUI

struct Post: Identifiable, Hashable {
    let id: UUID
    let author: Friend
    let rearPhotoAsset: String
    let selfiePhotoAsset: String
    let timestampText: String
    let isVibeMatched: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}
