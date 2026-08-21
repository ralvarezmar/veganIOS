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
