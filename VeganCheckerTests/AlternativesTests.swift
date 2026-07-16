import XCTest
@testable import VeganChecker

final class AlternativesTests: XCTestCase {
    func testMostSpecificCategoryTagUsesLastNonBlankTag() {
        XCTAssertEqual(
            mostSpecificCategoryTag(["en:foods", "en:snacks", "en:chips"]),
            "en:chips"
        )
        XCTAssertNil(mostSpecificCategoryTag([" ", ""]))
        XCTAssertNil(mostSpecificCategoryTag(nil))
    }

    func testSelectionFiltersCurrentDuplicateAndNonVeganProducts() {
        let candidates = [
            makeCandidate(code: "current", tags: ["en:vegan"]),
            makeCandidate(code: "vegan-1", tags: ["en:vegan"]),
            makeCandidate(code: "vegan-1", tags: ["en:vegan"]),
            makeCandidate(code: "not-vegan", tags: ["en:non-vegan"]),
            makeCandidate(code: "unknown", tags: nil)
        ]

        let selected = selectVeganAlternatives(
            from: candidates,
            excludingBarcode: "current",
            limit: 5
        )

        XCTAssertEqual(selected.compactMap(\.code), ["vegan-1"])
    }

    func testSelectionCapsResults() {
        let candidates = (0..<4).map {
            makeCandidate(code: "\($0)", tags: ["en:vegan"])
        }

        XCTAssertEqual(
            selectVeganAlternatives(from: candidates, excludingBarcode: "none", limit: 2).compactMap(\.code),
            ["0", "1"]
        )
    }

    private func makeCandidate(code: String, tags: [String]?) -> OpenFoodFactsSearchProduct {
        OpenFoodFactsSearchProduct(
            code: code,
            productName: code,
            brands: nil,
            imageUrl: nil,
            ingredientsAnalysisTags: tags,
            ingredients: nil
        )
    }
}
