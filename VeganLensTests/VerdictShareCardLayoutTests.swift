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

    private func product(
        labels: [String]? = nil,
        analysis: [String]? = nil,
        nutriscore: String? = nil,
        ecoscore: String? = nil,
        nova: Int? = nil,
        quantity: String? = nil,
        traces: [String]? = nil,
        allergens: [String]? = nil
    ) -> Product {
        Product(
            productName: "Galletas", brands: nil, imageUrl: nil, ingredientsText: nil,
            ingredientsAnalysisTags: analysis, categoriesTags: nil, labelsTags: labels,
            ingredients: nil, additivesTags: nil, allergensTags: allergens, nutriments: nil,
            nutriscoreGrade: nutriscore, ecoscoreGrade: ecoscore, novaGroup: nova,
            quantity: quantity, tracesTags: traces
        )
    }

    func testChipsListAvailableFactsInOrder() {
        let chips = verdictShareChips(for: product(nutriscore: "b", ecoscore: "a", nova: 3, quantity: " 500 g "))
        XCTAssertEqual(chips.count, 4)
        XCTAssertEqual(chips.first, "500 g")
        XCTAssertTrue(chips[1].hasSuffix(" B"))
        XCTAssertTrue(chips[2].hasSuffix(" A"))
        XCTAssertTrue(chips[3].hasSuffix(" 3"))
    }

    func testChipsSkipMissingOrInvalidFacts() {
        XCTAssertTrue(verdictShareChips(for: product(nutriscore: "not-applicable", nova: 7, quantity: " ")).isEmpty)
    }

    func testNotesShowSealTracesAndPalmOil() {
        let notes = verdictShareNotes(for: product(
            labels: ["en:organic", "en:vegan"],
            analysis: ["en:palm-oil-free"],
            traces: ["en:milk"]
        ))
        XCTAssertEqual(notes, [L("share_card_vegan_seal"), LF("share_card_traces", L("allergen_milk")), L("palm_oil_free")])
    }

    func testNotesIgnoreNonVeganLabelsAndMissingData() {
        XCTAssertTrue(verdictShareNotes(for: product(labels: ["en:non-vegan"])).isEmpty)
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
        let image = try XCTUnwrap(renderVerdictShareCard(content))
        XCTAssertEqual(image.size.width, 540, accuracy: 1)
        XCTAssertEqual(image.size.height, 675, accuracy: 1)
    }

    func testNotesListAllergensBeforeTraces() {
        let notes = verdictShareNotes(for: product(traces: ["en:milk"], allergens: ["en:gluten"]))
        XCTAssertEqual(notes, [LF("share_card_allergens", L("allergen_gluten")), LF("share_card_traces", L("allergen_milk"))])
    }
}
