import XCTest
import UIKit
@testable import VeganLens

final class PortadaSelectionTests: XCTestCase {
    func testSelectionUsesOnlyKnownCharacters() {
        for _ in 0..<100 {
            XCTAssertTrue(portadaCharacterNames.contains(selectPortadaCharacter(previous: nil)))
        }
    }

    func testSelectionDoesNotRepeatPreviousCharacter() {
        for previous in portadaCharacterNames {
            let selected = selectPortadaCharacter(previous: previous, randomIndex: { _ in 0 })
            XCTAssertNotEqual(selected, previous)
            XCTAssertTrue(portadaCharacterNames.contains(selected))
        }
    }

    func testTipSelectionUsesOnlyKnownTips() {
        for _ in 0..<100 {
            let selected = selectPortadaTip(previous: nil)
            XCTAssertTrue(portadaTipKeys.indices.contains(selected))
        }
    }

    func testTipSelectionDoesNotRepeatPreviousTip() {
        for previous in portadaTipKeys.indices {
            let selected = selectPortadaTip(previous: previous, randomIndex: { _ in 0 })
            XCTAssertNotEqual(selected, previous)
            XCTAssertTrue(portadaTipKeys.indices.contains(selected))
        }
    }

    func testTipSelectionIsDeterministicWithFixedRandom() {
        XCTAssertEqual(
            selectPortadaTip(previous: nil, randomIndex: { _ in 0 }),
            selectPortadaTip(previous: nil, randomIndex: { _ in 0 })
        )
        XCTAssertEqual(
            selectPortadaTip(previous: 3, randomIndex: { _ in 0 }),
            selectPortadaTip(previous: 3, randomIndex: { _ in 0 })
        )
    }

    func testPortadaTipsAreLocalizedInEveryLocale() throws {
        guard let appBundle = Bundle(identifier: "com.ralvarezmar.vcheck") else {
            XCTFail("The VeganLens application bundle is unavailable")
            return
        }

        for locale in ["es", "en", "de", "fr", "it", "pt"] {
            guard let stringsURL = appBundle.url(
                forResource: locale,
                withExtension: "lproj"
            )?.appendingPathComponent("Localizable.strings") else {
                XCTFail("Missing localization file for \(locale)")
                continue
            }
            let data = try Data(contentsOf: stringsURL)
            let entries = try XCTUnwrap(
                try PropertyListSerialization.propertyList(
                    from: data,
                    options: [],
                    format: nil
                ) as? [String: String]
            )
            for key in portadaTipKeys {
                XCTAssertFalse(
                    entries[key, default: ""].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    "Missing or empty \(key) in \(locale)"
                )
            }
        }
    }

    func testPortadaAssetsResolveInApplicationBundle() {
        guard let appBundle = Bundle(identifier: "com.ralvarezmar.vcheck") else {
            XCTFail("The VeganLens application bundle is unavailable")
            return
        }

        for character in portadaCharacterNames {
            XCTAssertNotNil(
                UIImage(
                    named: "portada_\(character)",
                    in: appBundle,
                    compatibleWith: nil
                ),
                "Missing asset for \(character)"
            )
        }
    }
}
