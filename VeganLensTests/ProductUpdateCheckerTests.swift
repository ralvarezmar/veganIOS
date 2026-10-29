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
}
