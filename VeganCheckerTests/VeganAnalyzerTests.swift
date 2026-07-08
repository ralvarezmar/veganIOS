import XCTest
@testable import VCheck

final class VeganAnalyzerTests: XCTestCase {
    func testDecisiveVeganTagReturnsVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:vegan"],
            ingredients: nil
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
    }

    func testDecisiveNonVeganTagReturnsNotVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:non-vegan"],
            ingredients: nil
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
    }

    func testDecisiveMaybeTagReturnsMaybe() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:maybe-vegan"],
            ingredients: nil
        )

        XCTAssertTrue(isStatus(analysis.status, .maybe))
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

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
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

        XCTAssertTrue(isStatus(analysis.status, .maybe))
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

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
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
}

private func isStatus(_ lhs: VeganStatus, _ rhs: VeganStatus) -> Bool {
    switch (lhs, rhs) {
    case (.vegan, .vegan), (.notVegan, .notVegan), (.maybe, .maybe), (.unknown, .unknown):
        return true
    default:
        return false
    }
}
