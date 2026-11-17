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
}

