import SwiftUI
import UIKit

struct VerdictShareCardContent {
    let title: String
    let brand: String?
    let headline: String
    let details: String
    let sourceName: String
    let status: VeganStatus
    let colorblindSafe: Bool
}

extension VerdictShareCardContent {
    init(product: Product, barcode: String, source: ProductSource, analysis: VeganAnalysis, colorblindSafe: Bool) {
        let trimmedTitle = product.productName?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBrand = product.brands?.trimmingCharacters(in: .whitespacesAndNewlines)
        let separator = ", "
        let details: String
        switch analysis.status {
        case .notVegan where !analysis.nonVeganIngredients.isEmpty:
            details = LF("share_card_non_vegan_ingredients", analysis.nonVeganIngredients.joined(separator: separator))
        case .maybe where !analysis.doubtfulIngredients.isEmpty:
            details = LF("share_card_doubtful_ingredients", analysis.doubtfulIngredients.joined(separator: separator))
        default:
            details = ""
        }
        self.init(
            title: (trimmedTitle?.isEmpty == false ? trimmedTitle : nil) ?? barcode,
            brand: trimmedBrand?.isEmpty == false ? trimmedBrand : nil,
            headline: verdictShareHeadline(for: analysis),
            details: details,
            sourceName: source.displayName,
            status: analysis.status,
            colorblindSafe: colorblindSafe
        )
    }
}

func verdictShareHeadline(for analysis: VeganAnalysis) -> String {
    switch analysis.status {
    case .vegan:
        return L("vegan_headline_vegan")
    case .notVegan:
        return L("vegan_headline_not_vegan")
    case .maybe:
        return analysis.heuristic ? L("vegan_headline_maybe_heuristic") : L("vegan_headline_maybe")
    case .unknown:
        return L("vegan_headline_unknown")
    }
}

struct VerdictShareCardView: View {
    let content: VerdictShareCardContent

    private var accent: Color {
        veganVerdictColor(for: content.status, colorblindSafe: content.colorblindSafe)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Capsule()
                .fill(accent)
                .frame(width: 60, height: 6)
            Text("VeganLens")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(accent)
            Text(content.headline)
                .font(.system(size: 28, weight: .heavy))
                .foregroundStyle(accent)
                .fixedSize(horizontal: false, vertical: true)
            VStack(alignment: .leading, spacing: 6) {
                Text(content.title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Color(white: 0.12))
                    .lineLimit(3)
                if let brand = content.brand {
                    Text(brand)
                        .font(.system(size: 18))
                        .foregroundStyle(Color(white: 0.42))
                        .lineLimit(1)
                }
            }
            if !content.details.isEmpty {
                Text(content.details)
                    .font(.system(size: 18))
                    .foregroundStyle(Color(white: 0.12))
                    .lineLimit(6)
            }
            Text(content.sourceName)
                .font(.system(size: 15))
                .foregroundStyle(Color(white: 0.42))
        }
        .padding(36)
        .frame(width: 468, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(36)
        .background(accent)
        .environment(\.colorScheme, .light)
    }
}

@MainActor
func renderVerdictShareCard(_ content: VerdictShareCardContent) -> UIImage? {
    let renderer = ImageRenderer(content: VerdictShareCardView(content: content))
    renderer.scale = 2
    return renderer.uiImage
}
