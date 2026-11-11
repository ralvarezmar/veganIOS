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

    func testAdditiveLanguageCodeUsesAppLanguagesAndFallsBackToSpanish() {
        XCTAssertEqual(additiveLanguageCode(preferredLanguages: ["de-DE"]), "de")
        XCTAssertEqual(additiveLanguageCode(preferredLanguages: ["pt_BR"]), "pt")
        XCTAssertEqual(additiveLanguageCode(preferredLanguages: ["nl-NL"]), "es")
    }

    func testEveryAdditiveHasNameAndNoteInAllAppLanguages() throws {
        let url = try XCTUnwrap(Bundle.main.url(forResource: "additives", withExtension: "json"))
        let root = try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any])
        let additives = try XCTUnwrap(root["additives"] as? [[String: Any]])
        XCTAssertGreaterThan(additives.count, 300)
        for additive in additives {
            let code = additive["code"] as? String ?? "?"
            let names = additive["name"] as? [String: String] ?? [:]
            let notes = additive["note"] as? [String: String] ?? [:]
            XCTAssertNotNil(additiveEntry(for: code), code)
            for language in ["es", "en", "pt", "it", "fr", "de"] {
                XCTAssertFalse(names[language]?.isEmpty ?? true, "\(code) \(language) name")
                XCTAssertFalse(notes[language]?.isEmpty ?? true, "\(code) \(language) note")
            }
        }
    }
}
