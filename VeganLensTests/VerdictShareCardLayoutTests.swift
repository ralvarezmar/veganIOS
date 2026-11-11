import XCTest
@testable import VeganLens

final class VerdictShareCardLayoutTests: XCTestCase {
    func testRandomMascotComesFromRotationAndVaries() {
        let picks = (0..<50).map { _ in randomVerdictShareMascot() }
        XCTAssertTrue(picks.allSatisfy(portadaCharacterNames.contains))
        XCTAssertGreaterThan(Set(picks).count, 1)
    }

    func testEveryVerdictHasASymbol() {
        XCTAssertEqual(
            [VeganStatus.vegan, .notVegan, .maybe, .unknown].map(verdictShareSymbolName(for:)),
            ["checkmark", "xmark", "questionmark", "minus"]
        )
    }

    @MainActor
    func testCardRendersAtFixedSize() throws {
        let content = VerdictShareCardContent(
            title: "Gambas al ajillo",
            brand: "Marca",
            headline: "No apto",
            details: "Ingredientes de origen animal: gamba",
            sourceName: "Open Food Facts",
            status: .notVegan,
            colorblindSafe: false
        )
        let image = try XCTUnwrap(renderVerdictShareCard(content))
        XCTAssertEqual(image.size.width, 540, accuracy: 1)
        XCTAssertEqual(image.size.height, 675, accuracy: 1)
    }
}
