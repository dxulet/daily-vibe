import SwiftUI

enum AvatarPalette {
    // Index 0 is the current-user tone; 1+ are friend tones.
    private static let slots: [Color] = [
        .vibeAvatarMuted,
        .red,
        .teal,
        .yellow,
        .mint,
        .orange,
    ]

    static func color(for friend: Friend) -> Color {
        let index = friend.avatarPaletteIndex
        guard slots.indices.contains(index) else { return slots[0] }
        return slots[index]
    }
}
