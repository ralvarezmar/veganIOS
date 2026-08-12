import XCTest
@testable import VeganLens

final class VeganAnalyzerTests: XCTestCase {
    func testDecisiveVeganTagReturnsVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:vegan"],
            ingredients: nil
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
        XCTAssertEqual(analysis.reason?.source, .decisiveTag)
    }

    func testDecisiveNonVeganTagReturnsNotVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:non-vegan"],
            ingredients: nil
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
        XCTAssertEqual(analysis.reason?.source, .decisiveTag)
    }

    func testDecisiveMaybeTagReturnsMaybe() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:maybe-vegan"],
            ingredients: nil
        )

        XCTAssertTrue(isStatus(analysis.status, .maybe))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
        XCTAssertEqual(analysis.reason?.source, .decisiveTag)
    }

    func testIngredientNoReturnsNotVeganAndCollectsNames() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:gelatin", vegan: "no", vegetarian: nil),
                OffIngredient(text: "en:gelatin", vegan: "no", vegetarian: nil),
            ]
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.nonVeganIngredients, ["Gelatin"])
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
        XCTAssertEqual(analysis.reason?.source, .structuredNonVeganIngredient)
    }

    func testIngredientMaybeReturnsMaybeAndCollectsNames() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:mono and diglycerides", vegan: "maybe", vegetarian: nil)
            ]
        )

        XCTAssertTrue(isStatus(analysis.status, .maybe))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertEqual(analysis.doubtfulIngredients, ["Mono And Diglycerides"])
        XCTAssertEqual(analysis.reason?.source, .structuredDoubtfulIngredient)
    }

    func testIngredientYesReturnsVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:water", vegan: "yes", vegetarian: nil)
            ]
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
        XCTAssertEqual(analysis.reason?.source, .structuredVeganIngredient)
    }

    func testUnknownWhenInputsAreEmptyOrNil() {
        let nilAnalysis = analyzeVegan(ingredientsAnalysisTags: nil, ingredients: nil)
        let emptyAnalysis = analyzeVegan(ingredientsAnalysisTags: [], ingredients: [])

        XCTAssertTrue(isStatus(nilAnalysis.status, .unknown))
        XCTAssertTrue(isStatus(emptyAnalysis.status, .unknown))
        XCTAssertTrue(nilAnalysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(nilAnalysis.doubtfulIngredients.isEmpty)
    }

    func testCleanFoodFactsLabelStripsPrefixAndNormalizesCasing() {
        XCTAssertEqual(cleanFoodFactsLabel("en:tree_nuts"), "Treenuts")
        XCTAssertEqual(cleanFoodFactsLabel("en:carmine"), "Carmine")
        XCTAssertEqual(cleanFoodFactsLabel("en:GLUTEN_free"), "Glutenfree")
    }

    func testCleanFoodFactsLabelReturnsNilForBlankValues() {
        XCTAssertNil(cleanFoodFactsLabel(nil))
        XCTAssertNil(cleanFoodFactsLabel(""))
        XCTAssertNil(cleanFoodFactsLabel("   "))
    }

    func testCleanFoodFactsLabelStripsMarkupBeforeDecodingEntities() {
        XCTAssertEqual(
            cleanFoodFactsLabel("<b>fr:lait crème</b> &amp; sucre"),
            "Lait Crème & Sucre"
        )
        XCTAssertEqual(
            cleanFoodFactsLabel("&lt;b&gt;lait&lt;/b&gt;"),
            "<b>lait</b>"
        )
    }

    func testUnknownIngredientTextUsesHeuristic() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: nil,
            ingredientsText: "Vollmilchpulver, Zucker"
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.nonVeganIngredients, ["Vollmilchpulver"])
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
        XCTAssertTrue(analysis.heuristic)
    }

    func testHeuristicDetectsAnimalIngredientInsideMarkup() {
        XCTAssertEqual(detectAnimalIngredients("<b>lait</b>, sucre").count, 1)
    }

    func testUnknownIngredientTextWithoutAnimalTermsBecomesMaybeHeuristic() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: nil,
            ingredientsText: "Zutaten: Weizenmehl, Zucker, Salz"
        )

        XCTAssertTrue(isStatus(analysis.status, .maybe))
        XCTAssertTrue(analysis.heuristic)
    }

    func testDecisiveVeganTagIsNeverOverriddenByHeuristic() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:vegan"],
            ingredients: nil,
            ingredientsText: "Vollmilchpulver, Zucker"
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertFalse(analysis.heuristic)
    }

    func testVeganSealResolvesUnknownAndProvidesReason() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: nil,
            labelsTags: ["en:certified-vegan"]
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertEqual(analysis.reason?.source, .veganSeal)
    }

    func testMeatAlternativeCategoryResolvesUnknownAndProvidesReason() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: nil,
            categoriesTags: ["en:plant-based-meat-substitutes"]
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertEqual(analysis.reason?.source, .meatAlternativeCategory)
    }

    func testVeganSealDoesNotOverrideStructuredNonVeganIngredient() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:gelatin", vegan: "no", vegetarian: nil)
            ],
            labelsTags: ["en:certified-vegan"]
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.reason?.source, .structuredNonVeganIngredient)
    }

    func testMeatAlternativeCategoryDoesNotOverrideStructuredNonVeganIngredient() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:gelatin", vegan: "no", vegetarian: nil)
            ],
            categoriesTags: ["en:meat-substitutes"]
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.reason?.source, .structuredNonVeganIngredient)
    }

    func testHeuristicReasonIsMarkedAsTextBased() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: nil,
            ingredientsText: "Vollmilchpulver, Zucker"
        )

        XCTAssertEqual(analysis.reason?.source, .heuristicText)
        XCTAssertEqual(analysis.reason?.evidence, ["Vollmilchpulver"])
    }
}

private func isStatus(_ lhs: VeganStatus, _ rhs: VeganStatus) -> Bool {
    switch (lhs, rhs) {
    case (.vegan, .vegan), (.notVegan, .notVegan), (.maybe, .maybe), (.unknown, .unknown):
        return true
    default:
        return false
    }
}
