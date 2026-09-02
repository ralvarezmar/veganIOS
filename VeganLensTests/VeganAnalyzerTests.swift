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

    func testAnimalAdditiveReturnsNotVeganAndReportsCode() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: nil,
            additivesTags: ["en:e441"]
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.nonVeganIngredients, ["E441"])
        XCTAssertEqual(analysis.reason?.source, .additiveAnimal)
        XCTAssertEqual(analysis.reason?.evidence, ["E441"])
    }

    func testAnimalAdditiveCodeInIngredientTextReturnsNotVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: nil,
            ingredientsText: "Ingredients: E120, water"
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.nonVeganIngredients, ["E120"])
        XCTAssertEqual(analysis.reason?.source, .additiveAnimal)
    }

    func testAnimalAdditiveRomanSubindexInIngredientTextReturnsNotVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: nil,
            ingredientsText: "Ingredients: E120II"
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.nonVeganIngredients, ["E120"])
        XCTAssertEqual(analysis.reason?.source, .additiveAnimal)
    }

    func testUncertainAdditiveReturnsMaybeWithoutCallingItNotVegan() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: nil,
            additivesTags: ["en:e270"]
        )

        XCTAssertTrue(isStatus(analysis.status, .maybe))
        XCTAssertEqual(analysis.doubtfulIngredients, ["E270"])
        XCTAssertEqual(analysis.reason?.source, .additiveUncertain)
    }

    func testUncertainAdditiveDoesNotDegradeExistingNonVeganIngredient() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:gelatin", vegan: "no", vegetarian: nil)
            ],
            additivesTags: ["en:e270"]
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.nonVeganIngredients, ["Gelatin"])
        XCTAssertEqual(analysis.reason?.source, .structuredNonVeganIngredient)
    }

    func testDecisiveVeganTagWinsOverUncertainAdditive() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:vegan"],
            ingredients: nil,
            additivesTags: ["en:e471"]
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
        XCTAssertEqual(analysis.reason?.source, .decisiveTag)
    }

    func testAnimalAdditiveOverridesDecisiveVeganTag() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:vegan"],
            ingredients: nil,
            additivesTags: ["en:e120"]
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.nonVeganIngredients, ["E120"])
        XCTAssertEqual(analysis.reason?.source, .additiveAnimal)
    }

    func testVegetalProductRemainsVeganWithPlantAdditive() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:water", vegan: "yes", vegetarian: nil)
            ],
            additivesTags: ["en:e140"]
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
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

    func testVeganSealReportsStructuredConflictAsMaybe() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:gelatin", vegan: "no", vegetarian: nil)
            ],
            labelsTags: ["en:certified-vegan"]
        )

        XCTAssertTrue(isStatus(analysis.status, .maybe))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertEqual(analysis.doubtfulIngredients, ["Gelatin"])
        XCTAssertEqual(analysis.reason?.source, .sealConflict)
    }

    func testVeganSealOverridesNonVeganTagWithoutAnimalIngredient() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:non-vegan"],
            ingredients: [
                OffIngredient(text: "Harina de trigo", vegan: "yes", vegetarian: nil)
            ],
            ingredientsText: "Harina de trigo, azúcar",
            labelsTags: ["en:certified-vegan"]
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertEqual(analysis.reason?.source, .veganSeal)
    }

    func testTaxonomizedMilkTraceIsFiltered() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: ["en:non-vegan"],
            ingredients: [
                OffIngredient(text: "en:milk", vegan: "no", vegetarian: nil)
            ],
            ingredientsText: "Harina de trigo, azúcar. Puede contener trazas de leche."
        )

        XCTAssertTrue(isStatus(analysis.status, .vegan))
        XCTAssertTrue(analysis.nonVeganIngredients.isEmpty)
        XCTAssertTrue(analysis.doubtfulIngredients.isEmpty)
        XCTAssertEqual(analysis.reason?.source, .tracesOnly)
        XCTAssertEqual(analysis.reason?.evidence, ["Milk"])
    }

    func testNestedAnimalSubIngredientIsNamed() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(
                    text: "Cobertura de chocolate",
                    vegan: nil,
                    vegetarian: nil,
                    ingredients: [
                        OffIngredient(text: "Leche en polvo", vegan: "no", vegetarian: nil)
                    ]
                )
            ],
            ingredientsText: "Cobertura de chocolate (azúcar, leche en polvo)"
        )

        XCTAssertTrue(isStatus(analysis.status, .notVegan))
        XCTAssertEqual(analysis.nonVeganIngredients, ["Leche En Polvo"])
    }

    func testRealGelatinConflictsWithVeganSeal() {
        let analysis = analyzeVegan(
            ingredientsAnalysisTags: nil,
            ingredients: [
                OffIngredient(text: "en:gelatin", vegan: "no", vegetarian: nil)
            ],
            labelsTags: ["en:vegan"]
        )

        XCTAssertTrue(isStatus(analysis.status, .maybe))
        XCTAssertEqual(analysis.doubtfulIngredients, ["Gelatin"])
        XCTAssertEqual(analysis.reason?.source, .sealConflict)
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
