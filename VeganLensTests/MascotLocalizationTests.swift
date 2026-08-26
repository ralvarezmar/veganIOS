import Foundation
import XCTest
@testable import VeganLens

final class MascotLocalizationTests: XCTestCase {
    func testEveryPortadaCharacterHasOneNonEmptyMascotNameInEveryLocale() throws {
        guard let appBundle = Bundle(identifier: "com.ralvarezmar.vcheck") else {
            XCTFail("The VeganLens application bundle is unavailable")
            return
        }

        let expectedKeys = Set(portadaCharacterNames.map { "mascot_\($0)" })
        for locale in ["es", "en", "de", "fr", "it", "pt"] {
            guard let stringsURL = appBundle.url(
                forResource: locale,
                withExtension: "lproj"
            )?.appendingPathComponent("Localizable.strings") else {
                XCTFail("Missing localization file for \(locale)")
                continue
            }
            let contents = try String(contentsOf: stringsURL, encoding: .utf8)
            let entries = try parseMascotEntries(contents)
            XCTAssertEqual(Set(entries.keys), expectedKeys, "Unexpected mascot keys in \(locale)")
            XCTAssertEqual(entries.count, expectedKeys.count, "Duplicate mascot keys in \(locale)")
            for key in expectedKeys {
                XCTAssertFalse(entries[key, default: ""].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    private func parseMascotEntries(_ contents: String) throws -> [String: String] {
        let pattern = #"^"(mascot_[^"]*)"\s*=\s*"((?:\\.|[^"])*)";$"#
        let expression = try NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        var entries: [String: String] = [:]
        for match in expression.matches(
            in: contents,
            range: NSRange(contents.startIndex..., in: contents)
        ) {
            guard
                let keyRange = Range(match.range(at: 1), in: contents),
                let valueRange = Range(match.range(at: 2), in: contents)
            else {
                continue
            }
            let key = String(contents[keyRange])
            XCTAssertNil(entries[key], "Duplicate mascot key \(key)")
            entries[key] = String(contents[valueRange])
        }
        return entries
    }
}
