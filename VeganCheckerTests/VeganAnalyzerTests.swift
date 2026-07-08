import XCTest
@testable import VeganChecker

final class VeganAnalyzerTests: XCTestCase {
    func testDecisiveVeganTagReturnsVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:vegan"],
            ingredients: nil
        )

        XCTAssertEqual(analysis.status, .vegan)
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
    }

    func testDecisiveNonVeganTagReturnsNotVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:non-vegan"],
            ingredients: nil
        )

        XCTAssertEqual(analysis.status, .notVegan)
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
    }

    func testDecisiveMaybeTagReturnsMaybe() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:maybe-vegan"],
            ingredients: nil
        )

        XCTAssertEqual(analysis.status, .maybe)
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
    }

    func testIngredientNoReturnsNotVeganAndCollectsNames() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:gelatin", vegan: "no", vegetarian: nil),
                OffIngredient(text: "en:gelatin", vegan: "no", vegetarian: nil),
            ]
        )

        XCTAssertEqual(analysis.status, .notVegan)
        XCTAssertEqual(analysis.nonVeganIngredients, ["Gelatin"])
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
    }

    func testIngredientMaybeReturnsMaybeAndCollectsNames() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:mono and diglycerides", vegan: "maybe", vegetarian: nil)
            ]
        )

        XCTAssertEqual(analysis.status, .maybe)
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertEqual(analysis.doubtfulIngredients, ["Mono And Diglycerides"])
    }

    func testIngredientYesReturnsVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:water", vegan: "yes", vegetarian: nil)
            ]
        )

        XCTAssertEqual(analysis.status, .vegan)
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
    }

    func testUnknownWhenInputsAreEmptyOrNil() {
        let nilAnalysis = analyzeVegan(ingredientsAnalysisTags: nil, ingredients: nil)
        let emptyAnalysis = analyzeVegan(ingredientsAnalysisTags: [], ingredients: [])

        XCTAssertEqual(nilAnalysis.status, .unknown)
        XCTAssertEqual(emptyAnalysis.status, .unknown)
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
}
