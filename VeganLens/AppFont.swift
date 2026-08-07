import SwiftUI

private struct HighLegibilityFontKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var highLegibilityFont: Bool {
        get { self[HighLegibilityFontKey.self] }
        set { self[HighLegibilityFontKey.self] = newValue }
    }
}

extension View {
    func appFont(_ style: Font.TextStyle, weight: Font.Weight? = nil) -> some View {
        modifier(AppFontModifier(style: style, weight: weight))
    }

    func appIconFont(size: CGFloat, weight: Font.Weight) -> some View {
        font(.system(size: size, weight: weight))
    }
}

private struct AppFontModifier: ViewModifier {
    @Environment(\.highLegibilityFont) private var highLegibilityFont

    let style: Font.TextStyle
    let weight: Font.Weight?

    func body(content: Content) -> some View {
        content.font(resolvedFont)
    }

    private var resolvedFont: Font {
        if highLegibilityFont {
            let font = Font.custom(
                "Atkinson Hyperlegible",
                size: defaultSize,
                relativeTo: style
            )
            return weight.map { font.weight($0) } ?? font
        }

        let font = nativeFont
        return weight.map { font.weight($0) } ?? font
    }

    private var defaultSize: CGFloat {
        switch style {
        case .largeTitle:
            return 34
        case .title:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline, .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 11
        @unknown default:
            return 17
        }
    }

    private var nativeFont: Font {
        switch style {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .body:
            return .body
        case .callout:
            return .callout
        case .subheadline:
            return .subheadline
        case .footnote:
            return .footnote
        case .caption:
            return .caption
        case .caption2:
            return .caption2
        @unknown default:
            return .body
        }
    }
}
