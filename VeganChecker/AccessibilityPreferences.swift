import SwiftUI

enum AccessibilityPreferences {
    static let colorblindPaletteKey = "accessibility_colorblind_palette"
    static let textSizeKey = "accessibility_text_size"
    static let highLegibilityFontKey = "accessibility_high_legibility_font"
}

enum AccessibilityTextSize: String {
    case normal
    case large
    case extraLarge = "extra_large"

    var dynamicTypeSize: DynamicTypeSize {
        switch self {
        case .normal:
            return .large
        case .large:
            return .xLarge
        case .extraLarge:
            return .accessibility1
        }
    }
}
