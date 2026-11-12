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
    var chips: [String] = []
    var notes: [String] = []
    var ingredients: String? = nil
}

func verdictShareIngredients(_ text: String?) -> String? {
    let cleaned = (text ?? "")
        .replacingOccurrences(of: "_", with: "")
        .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)
    return cleaned.isEmpty ? nil : cleaned
}

func verdictShareChips(for product: Product) -> [String] {
    let grades: Set<String> = ["A", "B", "C", "D", "E"]
    var chips: [String] = []
    if let quantity = product.quantity?.trimmingCharacters(in: .whitespacesAndNewlines), !quantity.isEmpty {
        chips.append(quantity)
    }
    if let grade = product.nutriscoreGrade?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(), grades.contains(grade) {
        chips.append("\(L("nutriscore_badge_title")) \(grade)")
    }
    if let grade = product.greenScoreGrade {
        chips.append("\(L("green_score_badge_title")) \(grade)")
    }
    if let nova = product.novaGroup, (1...4).contains(nova) {
        chips.append("\(L("nova_group_badge_title")) \(nova)")
    }
    return chips
}

func verdictShareNotes(for product: Product) -> [String] {
    var notes: [String] = []
    if product.labelsTags?.contains(where: isVeganSealTag) == true {
        notes.append(L("share_card_vegan_seal"))
    }
    let allergens = buildAllergenDisplayItems(tags: product.allergensTags ?? []).map(\.label)
    if !allergens.isEmpty {
        notes.append(LF("share_card_allergens", allergens.joined(separator: ", ")))
    }
    let traces = buildAllergenDisplayItems(tags: product.tracesTags ?? []).map(\.label)
    if !traces.isEmpty {
        notes.append(LF("share_card_traces", traces.joined(separator: ", ")))
    }
    switch palmOilStatus(product.ingredientsAnalysisTags) {
    case .present: notes.append(L("palm_oil_present"))
    case .maybe: notes.append(L("palm_oil_maybe"))
    case .free: notes.append(L("palm_oil_free"))
    case nil: break
    }
    return notes
}

struct VerdictShareChipsLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(subviews: subviews, maxWidth: proposal.width ?? .infinity)
        let width = rows.map { $0.width }.max() ?? 0
        let height = rows.map { $0.height }.reduce(0, +) + spacing * CGFloat(max(rows.count - 1, 0))
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in arrange(subviews: subviews, maxWidth: bounds.width) {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(ProposedViewSize(width: bounds.width, height: nil))
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(width: min(size.width, bounds.width), height: size.height))
                x += min(size.width, bounds.width) + spacing
            }
            y += row.height + spacing
        }
    }

    private struct Row {
        var indices: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func arrange(subviews: Subviews, maxWidth: CGFloat) -> [Row] {
        var rows: [Row] = []
        var current = Row()
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(ProposedViewSize(width: maxWidth, height: nil))
            let width = min(size.width, maxWidth)
            if !current.indices.isEmpty && current.width + spacing + width > maxWidth {
                rows.append(current)
                current = Row()
            }
            current.width += (current.indices.isEmpty ? 0 : spacing) + width
            current.height = max(current.height, size.height)
            current.indices.append(index)
        }
        if !current.indices.isEmpty { rows.append(current) }
        return rows
    }
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
        case .vegan:
            details = L("share_card_vegan_details")
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
            colorblindSafe: colorblindSafe,
            chips: verdictShareChips(for: product),
            notes: verdictShareNotes(for: product),
            ingredients: analysis.status == .vegan
                ? verdictShareIngredients(product.ingredientsText).map { LF("share_card_ingredients", $0) }
                : nil
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
                        .font(.system(size: 46, weight: .heavy))
                        .foregroundStyle(accent)
                }
                .frame(width: 88, height: 88)
                .padding(.top, 18)

                Text(content.headline)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 28)
                    .padding(.top, 12)
                    .frame(height: 70, alignment: .top)

                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.white)
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top, spacing: 16) {
                            if let productImage = content.productImage {
                                Image(uiImage: productImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .background(Color(white: 0.95))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text(content.title)
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundStyle(Color(white: 0.12))
                                    .lineLimit(4)
                                if let brand = content.brand {
                                    Text(brand)
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color(white: 0.42))
                                        .lineLimit(2)
                                }
                                if !content.chips.isEmpty {
                                    VerdictShareChipsLayout {
                                        ForEach(content.chips, id: \.self) { chip in
                                            Text(chip)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundStyle(Color(white: 0.12))
                                                .lineLimit(1)
                                                .padding(.horizontal, 11)
                                                .padding(.vertical, 5)
                                                .background(Capsule().fill(Color(white: 0.95)))
                                        }
                                    }
                                    .padding(.top, 6)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        if !content.details.isEmpty {
                            Capsule()
                                .fill(accent)
                                .frame(width: 48, height: 5)
                                .padding(.top, 12)
                            Text(content.details)
                                .font(.system(size: 19))
                                .foregroundStyle(Color(white: 0.12))
                                .lineLimit(4)
                                .padding(.trailing, 80)
                                .padding(.top, 8)
                        }
                        if !content.notes.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(content.notes, id: \.self) { note in
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Circle()
                                            .fill(accent)
                                            .frame(width: 8, height: 8)
                                        Text(note)
                                            .font(.system(size: 16))
                                            .foregroundStyle(Color(white: 0.25))
                                            .lineLimit(2)
                                    }
                                }
                            }
                            .padding(.trailing, 80)
                            .padding(.top, 12)
                            .layoutPriority(-1)
                        }
                        if let ingredients = content.ingredients {
                            Text(ingredients)
                                .font(.system(size: 15))
                                .foregroundStyle(Color(white: 0.42))
                                .lineLimit(5)
                                .padding(.trailing, 80)
                                .padding(.top, 12)
                                .layoutPriority(-2)
                        }
                        Spacer(minLength: 0)
                        Text([L("share_card_tagline"), content.sourceName].filter { !$0.isEmpty }.joined(separator: " · "))
                            .font(.system(size: 15))
                            .foregroundStyle(Color(white: 0.42))
                            .lineLimit(2)
                            .padding(.trailing, 80)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(32)
                    Image("portada_\(mascot)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 85, height: 85)
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
