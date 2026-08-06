import Foundation

func mostSpecificCategoryTag(_ tags: [String]?) -> String? {
    tags?
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
        .last
}

func selectVeganAlternatives(
    from candidates: [OpenFoodFactsSearchProduct],
    excludingBarcode: String,
    limit: Int = 6
) -> [OpenFoodFactsSearchProduct] {
    guard limit > 0 else { return [] }
    var seen = Set<String>()
    return candidates.filter { candidate in
        guard let code = candidate.code?.trimmingCharacters(in: .whitespacesAndNewlines),
              !code.isEmpty,
              code != excludingBarcode,
              seen.insert(code).inserted else {
            return false
        }
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: candidate.ingredientsAnalysisTags,
            ingredients: candidate.ingredients
        )
        return analysis.status == .vegan
    }.prefix(limit).map { $0 }
}
