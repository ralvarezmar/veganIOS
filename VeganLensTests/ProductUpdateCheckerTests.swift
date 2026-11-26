import XCTest
@testable import VeganLens

final class ProductUpdateCheckerTests: XCTestCase {
    private let now = Date(timeIntervalSince1970: 1_800_000_000)

    func testCheckIsDueWhenNeverRun() {
        XCTAssertTrue(isProductUpdateCheckDue(lastCheckAt: nil, now: now))
    }

    func testCheckIsNotDueWithinInterval() {
        XCTAssertFalse(isProductUpdateCheckDue(lastCheckAt: now.addingTimeInterval(-60), now: now))
    }

    func testCheckIsDueAfterIntervalOrClockChange() {
        XCTAssertTrue(isProductUpdateCheckDue(
            lastCheckAt: now.addingTimeInterval(-ProductUpdateSettings.checkInterval),
            now: now
        ))
        XCTAssertTrue(isProductUpdateCheckDue(lastCheckAt: now.addingTimeInterval(60), now: now))
    }

    func testRotatingBatchTakesNextItemsAndWrapsAround() {
        let items = Array(1...12)
        let first = rotatingBatch(items, offset: 0, limit: 10)
        XCTAssertEqual(first.items, Array(1...10))
        XCTAssertEqual(first.nextOffset, 10)
        let second = rotatingBatch(items, offset: first.nextOffset, limit: 10)
        XCTAssertEqual(second.items, [11, 12, 1, 2, 3, 4, 5, 6, 7, 8])
        XCTAssertEqual(second.nextOffset, 8)
    }

    func testRotatingBatchHandlesSmallListsAndStaleOffsets() {
        let small = rotatingBatch(["a", "b"], offset: 7, limit: 10)
        XCTAssertEqual(small.items, ["b", "a"])
        XCTAssertEqual(small.nextOffset, 1)
        XCTAssertTrue(rotatingBatch([String](), offset: 3, limit: 10).items.isEmpty)
    }

    func testFavoriteVerdictChangeIgnoresUnknownAndLegacyVerdicts() {
        XCTAssertTrue(hasFavoriteVerdictChanged(stored: "VEGAN", current: .notVegan))
        XCTAssertTrue(hasFavoriteVerdictChanged(stored: "UNKNOWN", current: .vegan))
        XCTAssertFalse(hasFavoriteVerdictChanged(stored: "VEGAN", current: .vegan))
        XCTAssertFalse(hasFavoriteVerdictChanged(stored: "VEGAN", current: .unknown))
        XCTAssertFalse(hasFavoriteVerdictChanged(stored: nil, current: .notVegan))
    }

    private func checked(_ verdict: VeganStatus, evidence: [String] = ["milk"]) -> CheckedProduct {
        CheckedProduct(
            barcode: "123",
            verdict: verdict.persistedValue,
            evidence: CheckEvidence(reason: "structuredNonVeganIngredient", examples: evidence),
            source: ProductSource.openFoodFacts.rawValue,
            checkedAt: now
        )
    }

    func testJournalRecordsVerdictChangeOnce() {
        let (journal, change) = ChangeJournal().observing(name: "Galletas", before: .vegan, after: checked(.notVegan))
        XCTAssertEqual(change?.beforeStatus, .vegan)
        XCTAssertEqual(change?.after.status, .notVegan)
        let (_, repeated) = journal.observing(name: "Galletas", before: .vegan, after: checked(.notVegan))
        XCTAssertNil(repeated)
    }

    func testJournalRecordsEvidenceChangeWithSameVerdict() {
        let (journal, _) = ChangeJournal().observing(name: "Galletas", before: .notVegan, after: checked(.notVegan))
        let (_, change) = journal.observing(name: "Galletas", before: .notVegan, after: checked(.notVegan, evidence: ["egg"]))
        XCTAssertEqual(change?.previousCheck?.evidence?.examples, ["milk"])
        XCTAssertEqual(change?.after.evidence?.examples, ["egg"])
    }

    func testEvidenceRestoresReasonSource() {
        let evidence = CheckEvidence(reason: "structuredNonVeganIngredient", examples: ["milk"])
        XCTAssertEqual(evidence.veganReason?.source, .structuredNonVeganIngredient)
        XCTAssertNil(CheckEvidence(reason: "removed", examples: []).veganReason)
    }

    func testUnfinishedBatchIsKeptUntilNextDailyCheck() {
        let previous = UpdateBatch(pending: ["a"], favoritesOffset: 1, historyOffset: 0, startedAt: now.addingTimeInterval(-60))
        XCTAssertEqual(planUpdateBatch(favorites: ["a", "b"], history: [], previous: previous, now: now), previous)
        let stale = UpdateBatch(pending: ["a"], favoritesOffset: 1, historyOffset: 0, startedAt: now.addingTimeInterval(-2 * 24 * 60 * 60))
        XCTAssertEqual(planUpdateBatch(favorites: ["a", "b"], history: ["c"], previous: stale, now: now).pending, ["a", "b", "c"])
    }

    func testIncompleteLookupsAreRetried() throws {
        let product = try JSONDecoder().decode(Product.self, from: Data(#"{"product_name":"X"}"#.utf8))
        XCTAssertFalse(isCompletedLookup(.error("offline")))
        XCTAssertTrue(isCompletedLookup(.notFound([])))
        XCTAssertFalse(isCompletedLookup(.success(FetchedProduct(product: product, source: .openFoodFacts, incompleteLookup: true))))
        XCTAssertTrue(isCompletedLookup(.success(FetchedProduct(product: product, source: .openFoodFacts))))
    }
}
