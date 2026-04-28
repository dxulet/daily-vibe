import SwiftUI

@main
struct DailyVibeApp: App {
    var body: some Scene {
        WindowGroup {
            RootRouter()
                .preferredColorScheme(.dark)
        }
    }
}
