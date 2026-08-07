import SwiftUI
import XCTest
@testable import VeganLens

final class VeganVerdictColorsTests: XCTestCase {
    func testColorblindSafePaletteResolvesEachVerdict() {
        XCTAssertEqual(
            veganVerdictColor(for: .vegan, colorblindSafe: true),
            Color(red: 0x00 / 255, green: 0x72 / 255, blue: 0xB2 / 255)
        )
        XCTAssertEqual(
            veganVerdictColor(for: .notVegan, colorblindSafe: true),
            Color(red: 0xD5 / 255, green: 0x5E / 255, blue: 0x00 / 255)
        )
        XCTAssertEqual(
            veganVerdictColor(for: .maybe, colorblindSafe: true),
            Color(red: 0xE6 / 255, green: 0x9F / 255, blue: 0x00 / 255)
        )
        XCTAssertEqual(
            veganVerdictColor(for: .unknown, colorblindSafe: true),
            Color(red: 0x6B / 255, green: 0x72 / 255, blue: 0x80 / 255)
        )
    }

    func testStandardPaletteRemainsUnchanged() {
        XCTAssertEqual(veganVerdictColor(for: .vegan, colorblindSafe: false), .green)
        XCTAssertEqual(veganVerdictColor(for: .notVegan, colorblindSafe: false), .red)
        XCTAssertEqual(veganVerdictColor(for: .maybe, colorblindSafe: false), .orange)
        XCTAssertEqual(
            veganVerdictColor(for: .unknown, colorblindSafe: false),
            Color(red: 0.45, green: 0.47, blue: 0.50)
        )
    }
}
