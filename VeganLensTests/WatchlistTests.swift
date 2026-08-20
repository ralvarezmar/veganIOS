import XCTest
@testable import VeganLens

final class WatchlistTests: XCTestCase {
    func testAdditiveMatchingNormalizesCaseSpacesAndPrefixes() {
        let product = makeProduct(
            ingredientsText: nil,
            additivesTags: ["en:e120", "E441", "en:e500"]
        )

        let matches = watchlistMatches(
            product: product,
            watchedAdditives: ["E 120", "e441"],
            watchedKeywords: []
        )

        XCTAssertEqual(matches.additives, ["E120", "E441"])
    }

    func testE270CatalogEntryProvidesLocalizedNameAndUncertainOrigin() {
        let additive = additiveEntry(for: "e270")
        let isEnglish = Locale.preferredLanguages.first?.lowercased().hasPrefix("en") == true

        XCTAssertEqual(additive?.info.commonName, isEnglish ? "Lactic acid" : "Ácido láctico")
        XCTAssertEqual(additive?.info.origin, .uncertain)
        XCTAssertEqual(
            additive?.info.note,
            isEnglish
                ? "Acidity regulator; almost always produced by fermenting plant sugars, but it may come from dairy."
                : "Regulador de acidez; se obtiene casi siempre por fermentación de azúcares vegetales, pero puede proceder de lácteos."
        )
    }

    func testE428CatalogEntryProvidesLocalizedNameAndAnimalOrigin() {
        let additive = additiveEntry(for: "E428")
        let isEnglish = Locale.preferredLanguages.first?.lowercased().hasPrefix("en") == true

        XCTAssertEqual(additive?.info.commonName, isEnglish ? "Gelatine" : "Gelatina")
        XCTAssertEqual(additive?.info.origin, .animal)
        XCTAssertEqual(
            additive?.info.note,
            isEnglish
                ? "Protein gelling agent obtained from animal collagen."
                : "Gelificante proteico obtenido de colágeno animal."
        )
    }

    func testKeywordMatchingIsCaseInsensitiveSubstring() {
        let product = makeProduct(
            ingredientsText: "Water, COCONUT OIL, salt",
            additivesTags: nil
        )

        let matches = watchlistMatches(
            product: product,
            watchedAdditives: [],
            watchedKeywords: ["coconut", "SALT"]
        )

        XCTAssertEqual(matches.ingredientKeywords, ["coconut", "SALT"])
    }

    func testMatchingDoesNotMatchDifferentAdditiveOrAbsentKeyword() {
        let product = makeProduct(
            ingredientsText: "Water and sunflower oil",
            additivesTags: ["en:e120"]
        )

        let matches = watchlistMatches(
            product: product,
            watchedAdditives: ["E12", "E441"],
            watchedKeywords: ["milk"]
        )

        XCTAssertTrue(matches.isEmpty)
    }

    func testPreferencesRoundTripAndRemoveBlankValues() {
        let encoded = WatchlistPreferences.encode([" E120 ", "", "coconut", "E120"])
        XCTAssertEqual(WatchlistPreferences.decode(encoded), ["E120", "coconut"])
    }

    private func makeProduct(
        ingredientsText: String?,
        additivesTags: [String]?
    ) -> Product {
        Product(
            productName: nil,
            brands: nil,
            imageUrl: nil,
            ingredientsText: ingredientsText,
            ingredientsAnalysisTags: nil,
            categoriesTags: nil,
            labelsTags: nil,
            ingredients: nil,
            additivesTags: additivesTags,
            allergensTags: nil,
            nutriments: nil,
            nutriscoreGrade: nil,
            ecoscoreGrade: nil,
            novaGroup: nil,
            quantity: nil
        )
    }
}
