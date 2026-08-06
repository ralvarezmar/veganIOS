import XCTest
@testable import VeganLens

final class IngredientOCRTests: XCTestCase {
    func testCleanerCollapsesLinesAndWhitespace() {
        XCTAssertEqual(
            cleanRecognizedIngredientText("  Ingredients:\n oats,   water,\n\n salt  "),
            "Ingredients: oats, water, salt"
        )
    }

    func testCleanerRemovesControlCharactersAndEmptyInput() {
        XCTAssertEqual(cleanRecognizedIngredientText(" \n\t \u{0} "), "")
        XCTAssertEqual(
            cleanRecognizedIngredientText("oats\u{0007}, water"),
            "oats, water"
        )
    }
}
