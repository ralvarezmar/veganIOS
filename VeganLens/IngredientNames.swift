import Foundation

private struct IngredientNamesFile: Decodable {
    let ingredients: [String: [String: String]]
}

private final class IngredientNamesBundleToken {}

private let ingredientNamesCatalog: [String: [String: String]] = {
    guard let url = Bundle(for: IngredientNamesBundleToken.self).url(forResource: "ingredient_names", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let file = try? JSONDecoder().decode(IngredientNamesFile.self, from: data) else {
        assertionFailure("Missing or invalid ingredient_names.json")
        return [:]
    }
    return file.ingredients
}()

private func languageOnly(_ code: String) -> String {
    String(code.lowercased().prefix { $0 != "-" && $0 != "_" })
}

/// Name of an Open Food Facts ingredient in `languageCode`, using its taxonomy id
/// (e.g. `en:shrimp`). Falls back to `fallback`, the text printed on the product.
func localizedIngredientName(offId: String?, fallback: String, languageCode: String) -> String {
    guard let id = offId?.trimmingCharacters(in: .whitespaces).lowercased(), !id.isEmpty else {
        return fallback
    }
    let language = languageOnly(languageCode)
    if let name = ingredientNamesCatalog[id]?[language] {
        return name
    }
    if language == "en", id.hasPrefix("en:") {
        return String(id.dropFirst(3)).replacingOccurrences(of: "-", with: " ")
    }
    return fallback
}

extension VeganAnalysis {
    func withLocalizedIngredientNames(
        ingredients: [OffIngredient]?,
        productLanguage: String?,
        languageCode: String
    ) -> VeganAnalysis {
        if let productLanguage, languageOnly(productLanguage) == languageOnly(languageCode) {
            return self
        }
        var names: [String: String] = [:]
        func visit(_ items: [OffIngredient]?) {
            for ingredient in items ?? [] {
                if let name = cleanFoodFactsLabel(ingredient.text) {
                    let localized = localizedIngredientName(offId: ingredient.id, fallback: name, languageCode: languageCode)
                    if localized != name {
                        names[name] = localized
                    }
                }
                visit(ingredient.ingredients)
            }
        }
        visit(ingredients)
        guard !names.isEmpty else { return self }

        func localized(_ values: [String]) -> [String] {
            var seen = Set<String>()
            return values.map { names[$0] ?? $0 }.filter { seen.insert($0).inserted }
        }
        return VeganAnalysis(
            status: status,
            nonVeganIngredients: localized(nonVeganIngredients),
            doubtfulIngredients: localized(doubtfulIngredients),
            heuristic: heuristic,
            reason: reason.map { VeganReason(source: $0.source, evidence: localized($0.evidence)) },
            hasIngredientData: hasIngredientData
        )
    }
}
