import SwiftUI
import UIKit

/// Renders a named asset-catalog image at fill aspect, with a caller-provided
/// placeholder shown when the asset isn't present in the bundle. The encapsulated
/// `UIImage(named:)` lookup keeps callers free of UIKit imports.
struct AssetImage<Placeholder: View>: View {
    let assetName: String
    let backgroundColor: Color
    @ViewBuilder let placeholder: () -> Placeholder

    var body: some View {
        ZStack {
            backgroundColor
            if UIImage(named: assetName) != nil {
                Image(assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder()
            }
        }
    }
}
