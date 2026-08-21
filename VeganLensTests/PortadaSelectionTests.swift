import XCTest
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
}
