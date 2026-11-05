import XCTest
@testable import VeganLens

final class IngredientGlossaryTests: XCTestCase {
    func testMatchesKeywordsAcrossLanguagesAndAccents() {
        XCTAssertEqual(glossaryIngredients(for: "Gélatine bovine"), [.gelatin])
        XCTAssertEqual(glossaryIngredients(for: "caseína"), [.casein])
        XCTAssertEqual(glossaryIngredients(for: "Blanc d’œuf"), [.eggAlbumin])
        XCTAssertEqual(glossaryIngredients(for: "E120"), [.carmine])
        XCTAssertEqual(glossaryIngredients(for: "Honig"), [.honey])
    }

    func testRequiresWordBoundaries() {
        XCTAssertTrue(glossaryIngredients(for: "melón y caramelo").isEmpty)
        XCTAssertTrue(glossaryIngredients(for: "E1200").isEmpty)
        XCTAssertTrue(glossaryIngredients(for: "Weizenmehl").isEmpty)
    }

    func testCollectsDistinctMatchesInGlossaryOrder() {
        XCTAssertEqual(glossaryIngredients(for: ["miel", "gelatina", "gelatin"]), [.gelatin, .honey])
    }

    func testQueryMatchingIgnoresCaseAndAccents() {
        XCTAssertTrue(glossaryQueryMatches("cochinilla", ["Carmín", "colorante de la Cochinilla"]))
        XCTAssertTrue(glossaryQueryMatches("e120", ["E120", nil]))
        XCTAssertTrue(glossaryQueryMatches("  ", ["anything"]))
        XCTAssertFalse(glossaryQueryMatches("soja", ["Gelatina", "huesos"]))
    }

    func testAdditiveListIsSortedAndSkipsRomanSubindicesWithParent() {
        let codes = allAdditiveEntries().map(\.code)
        XCTAssertFalse(codes.isEmpty)
        XCTAssertEqual(codes.first, "E100")
        XCTAssertTrue(codes.contains("E120"))
        XCTAssertEqual(Set(codes).count, codes.count)
    }
}
