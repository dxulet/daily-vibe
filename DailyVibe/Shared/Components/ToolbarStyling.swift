import SwiftUI

extension View {
    func vibeToolbarStyling() -> some View {
        self
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.vibeBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
