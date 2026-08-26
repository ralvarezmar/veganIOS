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
            let entries = try parseMascotEntries(at: stringsURL)
            XCTAssertEqual(Set(entries.keys), expectedKeys, "Unexpected mascot keys in \(locale)")
            XCTAssertEqual(entries.count, expectedKeys.count, "Duplicate mascot keys in \(locale)")
            for key in expectedKeys {
                XCTAssertFalse(entries[key, default: ""].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    private func parseMascotEntries(at url: URL) throws -> [String: String] {
        let data = try Data(contentsOf: url)
        guard let propertyList = try PropertyListSerialization.propertyList(
            from: data,
            options: [],
            format: nil
        ) as? [String: String] else {
            throw NSError(domain: "MascotLocalizationTests", code: 1)
        }
        return propertyList.filter { $0.key.hasPrefix("mascot_") }
    }
}
