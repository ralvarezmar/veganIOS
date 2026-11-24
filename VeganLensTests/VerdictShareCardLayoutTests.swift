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

    @MainActor
    func testCardWithFactsRendersAtFixedSize() throws {
        var content = VerdictShareCardContent(
            title: "Galletas de avena con chocolate negro",
            brand: "Marca",
            headline: "Apto para veganos",
            details: "",
            sourceName: "Open Food Facts",
            status: .vegan,
            colorblindSafe: false
        )
        content.chips = ["500 g", "Nutri-Score B", "Green Score A", "NOVA 3"]
        content.notes = ["Sello vegano certificado", "Puede contener trazas de: leche, huevos", "Sin aceite de palma"]
        content.checks = ["Sin lácteos", "Sin huevo", "Sin carne ni pescado", "Sin miel"]
        let image = try XCTUnwrap(renderVerdictShareCard(content))
        XCTAssertEqual(image.size.width, 540, accuracy: 1)
        XCTAssertEqual(image.size.height, 675, accuracy: 1)
    }
}
