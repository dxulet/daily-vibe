import SwiftUI

extension EnvironmentValues {
    @Entry var postRepository: any PostRepository = MockPostRepository()
    @Entry var currentUserProvider: any CurrentUserProvider = MockCurrentUserProvider()
}
