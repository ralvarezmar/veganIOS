import XCTest
@testable import VeganLens

final class AnimalIngredientHeuristicsTests: XCTestCase {
    func testDetectsOnlyClearlyAnimalIngredients() {
        XCTAssertTrue(detectAnimalIngredients("Zutaten: Weizenmehl, Zucker, Salz").isEmpty)
        XCTAssertEqual(detectAnimalIngredients("Vollmilchpulver, Zucker"), ["Vollmilchpulver"])
        XCTAssertTrue(detectAnimalIngredients("Kokosmilch, Zucker").isEmpty)
        XCTAssertTrue(detectAnimalIngredients("Leche de almendras").isEmpty)
        XCTAssertEqual(detectAnimalIngredients("Leche desnatada"), ["Leche Desnatada"])
        XCTAssertEqual(detectAnimalIngredients("Gelatine"), ["Gelatine"])
        XCTAssertEqual(detectAnimalIngredients("Zutaten: Vollei, Weizenmehl"), ["Vollei"])
        XCTAssertTrue(detectAnimalIngredients("Sugar, palm oil, salt").isEmpty)
    }

    func testPreservesOrderAndDeduplicatesDetectedSegments() {
        XCTAssertEqual(
            detectAnimalIngredients("Milk, Gelatin, Milk"),
            ["Milk", "Gelatin"]
        )
    }

    func testIgnoresTraceWarningsButKeepsEarlierAnimalIngredients() {
        XCTAssertTrue(
            detectAnimalIngredients("Harina de trigo, azúcar. Puede contener trazas de leche y huevo.").isEmpty
        )
        XCTAssertTrue(
            detectAnimalIngredients("Wheat flour, sugar. May contain traces of milk.").isEmpty
        )
        XCTAssertTrue(
            detectAnimalIngredients("Weizenmehl, Zucker. Kann Spuren von Milch enthalten.").isEmpty
        )
        XCTAssertEqual(
            detectAnimalIngredients("Leche entera, azúcar. Puede contener trazas de soja."),
            ["Leche Entera"]
        )
    }

    func testDetectsDairyNamedFlavourSegmentsAsDoubtfulIncludingGermanCompound() {
        let doubtful = [
            "aroma a mantequilla",
            "aroma natural de mantequilla",
            "butter flavouring",
            "arôme beurre",
            "Butteraroma",
            "aroma de queso"
        ]

        for segment in doubtful {
            XCTAssertTrue(containsDoubtfulFlavourIngredient(segment))
            XCTAssertFalse(containsAnimalIngredient(segment))
        }
        XCTAssertEqual(
            detectDoubtfulFlavourIngredients("Butteraroma"),
            ["Butteraroma"]
        )
    }

    func testGermanButteraromaCompoundUsesAromaSuffixWithoutBroadFalsePositive() {
        XCTAssertTrue(containsDoubtfulFlavourIngredient("Butteraroma"))
        XCTAssertFalse(containsDoubtfulFlavourIngredient("Butter"))
        XCTAssertFalse(containsDoubtfulFlavourIngredient("Buttercreme"))
    }

    func testKeepsAdditionalAnimalSignalsAndPlantQualifiersDecisive() {
        XCTAssertFalse(containsDoubtfulFlavourIngredient("aroma de mantequilla (lactosuero)"))
        XCTAssertTrue(containsAnimalIngredient("aroma de mantequilla (lactosuero)"))
        XCTAssertFalse(containsDoubtfulFlavourIngredient("aroma de mantequilla y gelatina"))
        XCTAssertTrue(containsAnimalIngredient("aroma de mantequilla y gelatina"))
        XCTAssertFalse(containsAnimalIngredient("mantequilla de cacahuete"))
    }
}
