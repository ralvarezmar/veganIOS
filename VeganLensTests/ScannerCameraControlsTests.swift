import XCTest
@testable import VeganLens

final class ScannerCameraControlsTests: XCTestCase {
    func testClampedZoomFactorKeepsDesiredValueWithinDeviceRange() {
        XCTAssertEqual(
            clampedZoomFactor(0.5, deviceMin: 1, deviceMax: 5),
            1
        )
        XCTAssertEqual(
            clampedZoomFactor(8, deviceMin: 1, deviceMax: 5),
            5
        )
        XCTAssertEqual(
            clampedZoomFactor(2, deviceMin: 1, deviceMax: 5),
            2
        )
        XCTAssertEqual(
            clampedZoomFactor(2, deviceMin: 2, deviceMax: 1),
            2
        )
        let once = clampedZoomFactor(3, deviceMin: 1, deviceMax: 5)
        XCTAssertEqual(
            clampedZoomFactor(once, deviceMin: 1, deviceMax: 5),
            once
        )
    }

    func testUsableMaxZoomFactorCapsDeviceMaximumAtFive() {
        XCTAssertEqual(usableMaxZoomFactor(2), 2)
        XCTAssertEqual(usableMaxZoomFactor(10), 5)
    }
}
