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
    var productImage: UIImage? = nil
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

func verdictShareSymbolName(for status: VeganStatus) -> String {
    switch status {
    case .vegan: return "checkmark"
    case .notVegan: return "xmark"
    case .maybe: return "questionmark"
    case .unknown: return "minus"
    }
}

func randomVerdictShareMascot() -> String {
    portadaCharacterNames.randomElement() ?? "apple"
}

struct VerdictShareCardView: View {
    let content: VerdictShareCardContent
    var mascot: String = randomVerdictShareMascot()

    private var accent: Color {
        veganVerdictColor(for: content.status, colorblindSafe: content.colorblindSafe)
    }

    var body: some View {
        ZStack(alignment: .top) {
            accent
            Circle()
                .fill(Color.white.opacity(0.11))
                .frame(width: 260, height: 260)
                .offset(x: 230, y: -90)
            Circle()
                .fill(Color.white.opacity(0.11))
                .frame(width: 170, height: 170)
                .offset(x: -250, y: 215)

            VStack(spacing: 0) {
                Text("VeganLens")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 36)
                    .padding(.top, 30)

                ZStack {
                    Circle().fill(.white)
                    Image(systemName: verdictShareSymbolName(for: content.status))
                        .font(.system(size: 70, weight: .heavy))
                        .foregroundStyle(accent)
                }
                .frame(width: 132, height: 132)
                .padding(.top, 34)

                Text(content.headline)
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 28)
                    .padding(.top, 20)
                    .frame(height: 100, alignment: .top)

                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.white)
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top, spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(content.title)
                                    .font(.system(size: 27, weight: .bold))
                                    .foregroundStyle(Color(white: 0.12))
                                    .lineLimit(3)
                                if let brand = content.brand {
                                    Text(brand)
                                        .font(.system(size: 19))
                                        .foregroundStyle(Color(white: 0.42))
                                        .lineLimit(1)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            if let productImage = content.productImage {
                                Image(uiImage: productImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .background(Color(white: 0.95))
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                        }
                        if !content.details.isEmpty {
                            Capsule()
                                .fill(accent)
                                .frame(width: 48, height: 5)
                                .padding(.top, 12)
                            Text(content.details)
                                .font(.system(size: 19))
                                .foregroundStyle(Color(white: 0.12))
                                .lineLimit(5)
                                .padding(.trailing, 130)
                                .padding(.top, 8)
                        }
                        Spacer(minLength: 0)
                        Text(content.sourceName)
                            .font(.system(size: 15))
                            .foregroundStyle(Color(white: 0.42))
                            .lineLimit(2)
                            .padding(.trailing, 130)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(32)
                    Image("portada_\(mascot)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.trailing, 12)
                        .padding(.bottom, 8)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
            }
        }
        .frame(width: 540, height: 675)
        .clipped()
        .environment(\.colorScheme, .light)
    }
}

@MainActor
func renderVerdictShareCard(_ content: VerdictShareCardContent) -> UIImage? {
    let renderer = ImageRenderer(content: VerdictShareCardView(content: content))
    renderer.scale = 2
    return renderer.uiImage
}

func loadShareProductImage(from urlString: String?) async -> UIImage? {
    guard let urlString, let url = URL(string: urlString) else { return nil }
    var request = URLRequest(url: url)
    request.timeoutInterval = 8
    guard let (data, _) = try? await URLSession.shared.data(for: request) else { return nil }
    return UIImage(data: data)
}
