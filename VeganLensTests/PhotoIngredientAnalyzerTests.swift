import XCTest
@testable import VeganLens

final class PhotoIngredientAnalyzerTests: XCTestCase {
    func testSelectsPreferredLanguageBlockAndKeepsTraceWarning() {
        let analysis = analyzePhotoIngredients(
            "Ingredientes: harina, azúcar. Puede contener leche. " +
                "Zutaten: Weizenmehl, Zucker, Milch.",
            preferredLanguage: "es"
        )

        XCTAssertEqual(analysis.status, .vegan)
        XCTAssertTrue(analysis.traceWarning)
        XCTAssertTrue(analysis.unrecognizedSegments.isEmpty)
    }

    func testUsesFirstBlockWhenPreferredLanguageIsAbsent() {
        let analysis = analyzePhotoIngredients(
            "Zutaten: Weizenmehl, Zucker, Sonnenblumenöl. " +
                "Ingredients: wheat flour, sugar, milk.",
            preferredLanguage: "it"
        )

        XCTAssertEqual(analysis.status, .vegan)
    }

    func testTrimsNutritionAndBestBeforeMarkers() {
        let analysis = analyzePhotoIngredients(
            "Ingredientes: harina, azúcar, sal. Información nutricional: " +
                "valor energético 100 kcal. Conservar en lugar fresco."
        )

        XCTAssertEqual(analysis.status, .vegan)
        XCTAssertTrue(analysis.unrecognizedSegments.isEmpty)
    }

    func testRecognizesHeaderWithoutDiacritics() {
        let analysis = analyzePhotoIngredients("COMPOSICION: harina, azúcar, sal")

        XCTAssertEqual(analysis.status, .vegan)
    }

    func testUsesExplicitLexemeMatchingModes() {
        XCTAssertTrue(
            matchesPhotoLexeme(
                "milch",
                mode: .tokenContains,
                normalized: "vollmilchpulver",
                tokens: ["vollmilchpulver"]
            )
        )
        XCTAssertTrue(
            matchesPhotoLexeme(
                "granatapfel",
                mode: .tokenPrefix,
                normalized: "granatapfelsaft",
                tokens: ["granatapfelsaft"]
            )
        )
        XCTAssertTrue(
            matchesPhotoLexeme(
                "aceituna",
                mode: .tokenExact,
                normalized: "aceituna",
                tokens: ["aceituna"]
            )
        )
        XCTAssertFalse(
            matchesPhotoLexeme(
                "tuna",
                mode: .tokenExact,
                normalized: "aceituna",
                tokens: ["aceituna"]
            )
        )
    }

    func testRecognizesGermanCompoundsAndKeepsFunctionalDescriptorUnknown() {
        let vegan = analyzePhotoIngredients(
            "Zutaten: Weizenmehl, Zucker, Sonnenblumenöl, Speisesalz.",
            preferredLanguage: "de"
        )
        let review = analyzePhotoIngredients(
            "Zutaten: Weizenmehl, Zucker, Sonnenblumenöl, Speisesalz, Backtriebmittel.",
            preferredLanguage: "de"
        )

        XCTAssertEqual(vegan.status, .vegan)
        XCTAssertEqual(review.status, .review)
        XCTAssertEqual(review.unrecognizedSegments, ["Backtriebmittel"])
    }

    func testReportsUnsupportedLanguageWhenNothingIsRecognized() {
        let analysis = analyzePhotoIngredients(
            "Ingrediënten: tarwebloem, suiker, zonnebloemolie, zout",
            preferredLanguage: "es"
        )

        XCTAssertEqual(analysis.status, .review)
        XCTAssertEqual(analysis.reasonSource, .languageNotRecognized)
    }
}
