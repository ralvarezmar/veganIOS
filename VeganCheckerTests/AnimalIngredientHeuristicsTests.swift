import XCTest
@testable import VeganChecker

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
}
