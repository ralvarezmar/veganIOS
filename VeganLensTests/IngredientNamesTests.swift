import XCTest
@testable import VeganLens

final class IngredientNamesTests: XCTestCase {
    func testKnownTaxonomyIdIsTranslatedToAppLanguage() {
        XCTAssertEqual(localizedIngredientName(offId: "en:shrimp", fallback: "garnaal", languageCode: "es"), "gamba")
        XCTAssertEqual(localizedIngredientName(offId: "en:shrimp", fallback: "garnaal", languageCode: "de-DE"), "Garnele")
        XCTAssertEqual(
            localizedIngredientName(offId: "EN:Skimmed-Milk-Powder", fallback: "magermelkpoeder", languageCode: "fr"),
            "lait écrémé en poudre"
        )
    }

    func testUnknownIdFallsBackToEnglishIdOrProductText() {
        XCTAssertEqual(localizedIngredientName(offId: "en:sea-urchin", fallback: "zee-egel", languageCode: "en"), "sea urchin")
        XCTAssertEqual(localizedIngredientName(offId: "en:sea-urchin", fallback: "zee-egel", languageCode: "es"), "zee-egel")
        XCTAssertEqual(localizedIngredientName(offId: nil, fallback: "garnaal", languageCode: "es"), "garnaal")
        XCTAssertEqual(localizedIngredientName(offId: "en:shrimp", fallback: "garnaal", languageCode: "nl"), "garnaal")
    }

    func testProductAnalysisShowsNonVeganIngredientInAppLanguage() {
        let analysis = analyzeVegan(makeProduct(language: "nl", ingredientText: "garnaal"), displayLanguage: "es")

        XCTAssertEqual(analysis.status, .notVegan)
        XCTAssertEqual(analysis.nonVeganIngredients, ["gamba"])
        XCTAssertEqual(analysis.reason?.evidence, ["gamba"])
    }

    func testProductInAppLanguageKeepsOriginalText() {
        let product = makeProduct(language: "es", ingredientText: "gambas peladas")

        let original = [cleanFoodFactsLabel("gambas peladas")].compactMap { $0 }
        XCTAssertEqual(analyzeVegan(product, displayLanguage: "es").nonVeganIngredients, original)
        XCTAssertEqual(analyzeVegan(product, displayLanguage: nil).nonVeganIngredients, original)
    }

    private func makeProduct(language: String, ingredientText: String) -> Product {
        Product(
            productName: nil,
            brands: nil,
            imageUrl: nil,
            ingredientsText: nil,
            ingredientsAnalysisTags: nil,
            categoriesTags: nil,
            labelsTags: nil,
            ingredients: [
                OffIngredient(id: "en:water", text: "water", vegan: "yes", vegetarian: "yes"),
                OffIngredient(id: "en:shrimp", text: ingredientText, vegan: "no", vegetarian: "no")
            ],
            additivesTags: nil,
            allergensTags: nil,
            nutriments: nil,
            nutriscoreGrade: nil,
            ecoscoreGrade: nil,
            novaGroup: nil,
            quantity: nil,
            ingredientsLanguage: language
        )
    }
}
