import XCTest
@testable import VeganLens

final class ResultAccessibilityTextTests: XCTestCase {
    func testCombinesVerdictAccessibilityText() {
        XCTAssertEqual(
            verdictAccessibilityText(
                headline: "Vegan",
                subtitle: "No animal ingredients",
                explanation: "Explanation"
            ),
            "Vegan. No animal ingredients. Explanation"
        )
        XCTAssertEqual(
            verdictAccessibilityText(
                headline: "Vegan",
                subtitle: "No animal ingredients",
                explanation: nil
            ),
            "Vegan. No animal ingredients"
        )
    }
}
