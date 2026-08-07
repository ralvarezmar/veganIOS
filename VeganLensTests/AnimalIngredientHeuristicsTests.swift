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
}
